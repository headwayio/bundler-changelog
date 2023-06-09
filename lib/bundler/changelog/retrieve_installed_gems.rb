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
        # definition = Bundler::Definition.build(Bundler.default_gemfile, Bundler.default_lockfile, true, optional_groups: @group || [])

        Bundler.ui.silence { definition.resolve_remotely! }
        # Bundler.ui.silence { definition.resolve_with_cache! }

        definition
      end

      def filtered_gems(definition, specs)
        if @group
          # TODO: Not yet functional
          definition.specs_for([@group])
        elsif @gem_names
          specs.select { |spec| @gem_names.include?(spec.name) }
        else
          specs
        end
      end
    end
  end
end
