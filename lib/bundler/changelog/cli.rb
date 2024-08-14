# frozen_string_literal: true

require "dry/cli"

require_relative "runner"
require_relative "version"

module Bundler
  module Changelog
    module CLI
      # Main entry point for changelog script.
      module Commands
        extend Dry::CLI::Registry

        # Displays the version of the Gem.
        class Version < Dry::CLI::Command
          desc "Prints version"

          def call(*)
            puts Bundler::Changelog::VERSION
          end
        end

        # Lists the changelog entries for outdated gems.
        class Changelogs < Dry::CLI::Command
          desc "Output changelog entries for all outdated gems"

          option :group, desc: "Gemfile group to view"
          option :gems, type: :array, desc: "List of gems to view"

          example [
            "                     # Outputs newer changelog entries for outdated gems",
            "--group development  # Outputs newer changelog entries for gems in the development group",
            "--gems rake,rspec    # Outputs newer changelog entries for Rake and RSpec"
          ]

          def call(group: nil, gems: nil, **)
            Bundler::Changelog::Runner.new.run(group, gems)
          end
        end

        register "version", Version, aliases: ["v", "-v", "--version"]
        register "list", Changelogs
      end
    end
  end
end
