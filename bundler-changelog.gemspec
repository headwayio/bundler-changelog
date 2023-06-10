# frozen_string_literal: true

require_relative "lib/bundler/changelog/version"

Gem::Specification.new do |spec|
  spec.name = "bundler-changelog"
  spec.version = Bundler::Changelog::VERSION
  spec.authors = ["Noah Settersten"]
  spec.email = ["noah@headway.io"]

  spec.summary = "See the list of changes for your outdated gems."
  spec.description = "Collects the Changelog entries for the outdated gems in your Gemfile to allow " \
                     "for easy review of updates."
  spec.homepage = "https://github.com/noahsettersten/bundler-changelog"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/noahsettersten/bundler-changelog"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .rspec .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dry-cli", "~> 1.0"
  spec.add_dependency "dry-monads", "~> 1.3"
  spec.add_dependency "dry-struct", "~> 1.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
