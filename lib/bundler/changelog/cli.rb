# frozen_string_literal: true

require "dry/monads"

require_relative "./retrieve_outdated"
require_relative "./parse_changelog"

module Bundler
  module Changelog
    # Main entry point for changelog script.
    class CLI
      include Dry::Monads[:task, :list]

      def run
        puts "Retrieving outdated gems..."
        outdated_gems = Bundler::Changelog::RetrieveOutdated.new.run
        gems_without_changelog, gems_with_changelog = partition_results(outdated_gems)
        parsed_changelogs = parse_changelogs_async(gems_with_changelog)

        output_changelogs(parsed_changelogs)
        output_skipped_gems(gems_without_changelog)
      end

      private

      def parse_changelogs_async(gem_specs)
        # See this blog article for a helpful understanding of dry-monads's Task which helped with this logic:
        # https://troikatech.com/blog/2022/02/08/concurrent-io-using-dry-monads-tasks/
        List[*gem_specs]
          .typed(Task)
          .traverse { |data| task_for_changelog(data) }
          .value!
      end

      def task_for_changelog(data)
        name = data[:current_spec].name

        Task do
          [changelog_header(name, data)] +
            Bundler::Changelog::ParseChangelog
            .new(data[:changelog_uri])
            .run(data[:newer_versions])
            .value_or(["\n"])
        end
      end

      def output_changelogs(changelogs)
        changelogs.value.each do |entries|
          entries.each do |entry|
            puts entry
          end
        end
      end

      def output_skipped_gems(gems_without_changelog)
        gem_names = gems_without_changelog.map { |gem| gem[:current_spec].name }.join(", ")
        puts "Skipped because no changelog was found: #{gem_names}"
      end

      def partition_results(results)
        results.partition { |v| v[:changelog_uri].nil? } # .map(&:to_h)
      end

      def changelog_header(name, data)
        "Changelog for #{name} (#{data[:current_spec].version}): #{data[:changelog_uri]}"
      end
    end
  end
end
