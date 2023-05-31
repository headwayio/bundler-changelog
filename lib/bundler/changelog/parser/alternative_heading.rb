# frozen_string_literal: true

module Bundler
  module Changelog
    module Parser
      # Strategy: Split on alternative Markdown headings followed by ------------------
      class AlternativeHeading
        DIVIDER = "------------------"

        def initialize
          @versions = {}
        end

        def parse(lines)
          version_number = ""
          @versions[version_number] = []

          lines.each_with_index do |line, index|
            if lines[index + 1] == DIVIDER
              version_number = line
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
