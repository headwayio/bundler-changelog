# frozen_string_literal: true

require "dry-struct"

# Create a local module for containing Dry.Types
module Types
  include Dry.Types()
end

# Represents an individual gem that has newer versions available
class OutdatedVersion < Dry::Struct
  attribute :current_spec, Types::Instance(Bundler::LazySpecification) | Types::Instance(Gem::Specification) | Types::Instance(Bundler::StubSpecification)
  attribute :changelog_uri, Types::String.optional
  attribute :newer_versions, Types::Array.of(Types::Instance(Gem::Version))
end
