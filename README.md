# Bundler::Changelog

Gathers the recent changelog entries for your outdated gems to save you time when researching upgrades.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add bundler-changelog

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bundler-changelog

## Usage

    # Show changelog entries for all outdated gems
    $ bundler-changelog list

    # Show entries for a specific group from your Gemfile
    $ bundler-changelog list --group development

    # Show entries for specific gems
    $ bundler-changelog list --gems rake,rspec

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Ideas for Expansion

- New option: Pick the first outdated gem and show only its changelog entries
- New option: Only show a single version for each gem for gradual updates. Or even only the latest version. Or only major versions that have breaking changes.
- When run without arguments, use a TUI similar to yarn's `upgrade-interactive`: Show a list of outdated gems in selectable list on the left and then show the current gem's changelog entries on the right.

      --------------------|
      | Gem 1 | Changelog |
      | Gem 2 | ...       |
      | Gem 3 | ...       |
      --------------------|

- Implement as a [Bundler plugin](https://bundler.io/guides/bundler_plugins.html) instead of a standalone tool.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bundler-changelog.
