# frozen_string_literal: true

module Bundler
  module Changelog
    # Downloads changelog contents from a URI
    class DownloadChangelog
      def initialize(uri)
        uri = uri.gsub("github.com", "raw.githubusercontent.com")
                 .gsub("/tree/", "/")
                 .gsub("/blob/", "/")

        @uri = URI(uri)
      end

      def run
        # Replace https://github.com with https://raw.githubusercontent.com
        # https://raw.githubusercontent.com/aws/aws-sdk-ruby/version-3/gems/aws-sdk-core/CHANGELOG.md

        response = Net::HTTP.get(@uri)
        response.split("\n")
      end
    end
  end
end
