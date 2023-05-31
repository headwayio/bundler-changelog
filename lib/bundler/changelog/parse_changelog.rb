# frozen_string_literal: true

require "net/http"
require "uri"

require_relative "./parser/alternative_heading"
require_relative "./parser/heading"

module Bundler
  module Changelog
    # Retrieves changelog contents from a URI and attempts to parse the contents for each version.
    class ParseChangelog
      PARSERS = [Parser::Heading, Parser::AlternativeHeading].freeze

      def initialize(uri)
        uri = uri.gsub("github.com", "raw.githubusercontent.com")
                 .gsub("/tree/", "/")
                 .gsub("/blob/", "/")

        @uri = URI(uri)
      end

      def run(versions)
        # Parse and get changelog entries for passed versions
        lines = read_uri
        changelog_entries = parse_changelog(lines)
        return if changelog_entries.empty?

        versions.each do |version|
          entry = find_entry_for_version(changelog_entries, version)
          next if entry.nil?

          # puts "  Changes for #{version}:"
          entry.each do |entry_line|
            puts "  #{entry_line}"
          end
        end
      end

      private

      def read_uri
        # Replace https://github.com with https://raw.githubusercontent.com
        # https://raw.githubusercontent.com/aws/aws-sdk-ruby/version-3/gems/aws-sdk-core/CHANGELOG.md

        response = Net::HTTP.get(@uri)
        response.split("\n")
      end

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
        if key.nil?
          puts "  Couldn't find changelog entry for version #{version}"
          return nil
        end

        # puts "Looking for version #{version} and found key #{key}"

        changelog_entries[key]
      end
    end
  end
end
