# frozen_string_literal: true

module Bundler
  module Changelog
    module Parser
      # Strategy 2: Versions are embedded in second-level headings
      #    ## Rails 7.0.4 (September 09, 2022) ##
      class Heading
        def initialize
          @versions = {}
        end

        def parse(lines)
          version_number = ""
          @versions[version_number] = []

          lines.each do |line|
            if line.start_with?("## ")
              version_number = line.gsub("## ", "")
              @versions[version_number] = []
            end

            @versions[version_number] << line
          end

          @versions
        end
      end
    end
  end
end
