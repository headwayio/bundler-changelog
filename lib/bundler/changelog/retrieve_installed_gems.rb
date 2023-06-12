# frozen_string_literal: true

require "bundler"

module Bundler
  module Changelog
    # Retrieve a list of installed gems from the Gemfile.
    class RetrieveInstalledGems
      def initialize(group, gem_names)
        @group = group
        @gem_names = gem_names
      end

      def run
        specs = Bundler.definition.resolve
        definition = resolve_bundler_definitions!

        filtered_gems(definition, specs).sort_by(&:name).uniq(&:name)
      end

      private

      def resolve_bundler_definitions!
        # Show changes for all outdated gems
        definition = Bundler.definition(true)

        Bundler.ui.silence { definition.resolve_remotely! }
        # Bundler.ui.silence { definition.resolve_with_cache! }

        definition
      end

      def filtered_gems(definition, specs)
        if @group
          # `specs_for` appears to include gems in the default group, even if it's not included in the array argument.
          # To address this, we gather specs for :default and then remove them from result.
          names_in_selected_group = definition.specs_for([@group]).map(&:name)
          names_in_selected_group_only = exclude_gems_in_default_group(definition, names_in_selected_group)

          # It seems that `specs_for` returns the latest available version for a given gem, not necessarily the
          # version in the lockfile. To ensure we work on the lockfile entries, we use the results of `specs_for`
          # to filter the resolved specs.
          specs.select { |spec| names_in_selected_group_only.include?(spec.name) }
        elsif @gem_names
          specs.select { |spec| @gem_names.include?(spec.name) }
        else
          specs
        end
      end

      def exclude_gems_in_default_group(definition, names_in_selected_group)
        if @group == :default
          names_in_selected_group
        else
          names_in_default_group = definition.specs_for([:default]).map(&:name)
          names_in_selected_group - names_in_default_group
        end
      end
    end
  end
end
