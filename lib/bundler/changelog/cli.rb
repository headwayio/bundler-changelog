# frozen_string_literal: true

require_relative "./retrieve_outdated"
require_relative "./parse_changelog"

module Bundler
  module Changelog
    # Main entry point for changelog script.
    class CLI
      def run
        puts "Retrieving outdated gems..."
        results = Bundler::Changelog::RetrieveOutdated.new.run
        without_changelog, with_changelog = partition_results(results)

        with_changelog.each do |name, data|
          print_header(name, data)

          puts Bundler::Changelog::ParseChangelog
            .new(data[:changelog_uri])
            .run(data[:newer_versions])
            .value_or("\n")
        end

        puts "Skipped because no changelog was found: #{without_changelog.keys.join(", ")}"
      end

      private

      def partition_results(results)
        results.partition { |_k, v| v[:changelog_uri].nil? }.map(&:to_h)
      end

      def print_header(name, data)
        puts "Changelog for #{name} (#{data[:current_spec].version}): #{data[:changelog_uri]}"
      end
    end
  end
end
