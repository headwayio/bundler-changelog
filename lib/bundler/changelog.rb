# frozen_string_literal: true

require "bundler"
# require "bundler/plugin/api"

module Bundler
  # Collects the Changelog entries for the outdated gems in your Gemfile to allow for easy review of updates.
  module Changelog
    #   class Error < StandardError; end
    #   # Your code goes here...
    #
    #   class RunCommand < Bundler::Plugin::API
    #     command "changes"
    #
    #     def exec(command, args)
    #       if args.empty?
    #         run
    #       else
    #         # Show changes for a specific gem
    #         puts "You called #{command} with arguments: #{args}"
    #       end
    #     end
    #   end
  end
end
