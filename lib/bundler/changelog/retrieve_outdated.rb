# frozen_string_literal: true

require "bundler"
require_relative "./outdated_version"

# Heavily based on the logic in Bundler's Bundler::CLI::Outdated class:
# - https://www.rubydoc.info/gems/bundler/Bundler/CLI/Outdated#run-instance_method
# - https://github.com/rubygems/rubygems/blob/master/bundler/lib/bundler/cli/outdated.rb
module Bundler
  module Changelog
    # Gets the list of outdated gems and the newer versions that are available.
    class RetrieveOutdated
      def run
        result = []
        current_specs = Bundler.definition.resolve.sort_by(&:name).uniq(&:name)
        definition = resolve_bundler_definitions!

        current_specs.each do |current_spec|
          outdated = outdated_versions_for_spec(definition, current_spec)
          next unless outdated[:newer_versions].count.positive?

          result << outdated
        end

        result
      end

      private

      def resolve_bundler_definitions!
        # Show changes for all outdated gems
        definition = Bundler.definition(true)
        Bundler.ui.silence { definition.resolve_remotely! }
        # Bundler.ui.silence { definition.resolve_with_cache! }

        definition
      end

      def outdated_versions_for_spec(definition, current_spec)
        changelog_uri = nil
        newer_versions = []

        current_version = Gem::Version.new(current_spec.version)
        active_specs = newer_specs_for_gem(definition, current_spec)

        active_specs.each do |newer_spec|
          changelog_uri ||= newer_spec.metadata["changelog_uri"]
          next unless outdated?(newer_spec, current_version)

          newer_versions << newer_spec.version
        end

        OutdatedVersion.new(current_spec: current_spec, changelog_uri: changelog_uri, newer_versions: newer_versions)
      end

      def newer_specs_for_gem(definition, current_spec)
        active_specs = retrieve_active_specs(definition, current_spec)
        return [] if active_specs.nil? || active_specs.empty?

        current_version = Gem::Version.new(current_spec.version)
        return [] unless outdated?(active_specs.last, current_version)

        active_specs
      end

      def outdated?(active_spec, current_version)
        Gem::Version.new(active_spec.version) > current_version
      end

      def retrieve_active_specs(definition, current_spec)
        active_spec = definition.resolve.find_by_name_and_platform(current_spec.name, current_spec.platform)
        return unless active_spec

        active_specs = active_spec.source.specs.search(current_spec.name).select do |spec|
          spec.match_platform(current_spec.platform)
        end.sort_by(&:version)

        filter_prerelease(active_specs, current_spec.version.prerelease?)
      end

      def filter_prerelease(active_specs, is_current_prerelease)
        if !is_current_prerelease && active_specs.size > 1 # && !options[:pre]
          active_specs.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? }
        end

        active_specs
      end
    end
  end
end
