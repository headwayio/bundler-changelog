# frozen_string_literal: true

require "net/http"
require "uri"
require "dry/monads"

require_relative "parser/alternative_heading"
require_relative "parser/heading"
require_relative "download_changelog"

module Bundler
  module Changelog
    # Retrieves changelog contents from a URI and attempts to parse the contents for each version.
    class ParseChangelog
      include Dry::Monads[:result]

      PARSERS = [Parser::Heading, Parser::AlternativeHeading].freeze

      def initialize(uri)
        @uri = uri
      end

      def run(versions)
        # Parse and get changelog entries for passed versions
        lines = Bundler::Changelog::DownloadChangelog.new(@uri).run
        changelog_entries = parse_changelog(lines)
        return Failure(:no_changelog_entries_found) if changelog_entries.empty?

        entries = versions.map do |version|
          find_entry_for_version(changelog_entries, version).value_or(nil)
        end

        Success(entries.compact)
      end

      private

      def parse_changelog(lines)
        changelog_entries = {}

        PARSERS.each do |parser|
          changelog_entries = parser.new.parse(lines)

          break if changelog_valid?(changelog_entries)

          changelog_entries = {}
        end

        changelog_entries
      end

      def changelog_valid?(changelog_entries)
        !changelog_entries.nil? && !changelog_entries.empty? && changelog_entries.keys != [""]
      end

      def find_entry_for_version(changelog_entries, version)
        key = changelog_entries.keys.detect { |k| k.match?(/#{version}/) }
        return Failure("Couldn't find changelog entry for version #{version}") if key.nil?

        Success(changelog_entries[key])
      end
    end
  end
end
