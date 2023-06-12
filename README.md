# Bundler::Changelog

`bundler-changelog` is a command-line tool that gathers the recent changelog entries for your outdated gems to save you time when researching upgrades.

## Installation

This gem is not on rubygems yet. For now, you can add the gem to your project with:

    gem 'bundler-changelog', github: 'noahsettersten/bundler-changelog', require: false, group: :development

<!--
Install the gem and add to the application's Gemfile by executing:

    $ bundle add bundler-changelog

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bundler-changelog
-->

## Example Output

    $ bundler-changelog list
    Gathering changelog entries for outdated gems...

    - capybara (Currently installed: 3.39.1): https://github.com/teamcapybara/capybara/blob/master/History.md
    - rack (Currently installed: 2.2.7): https://github.com/rack/rack/blob/master/CHANGELOG.md
        ## [3.0.0] - 2022-09-06
        ...

    - regexp_parser (Currently installed: 2.8.0): https://github.com/ammar/regexp_parser/blob/master/CHANGELOG.md
        ## [2.8.1] - 2023-06-10 - [Janosch Müller](mailto:janosch84@gmail.com)

        ### Fixed

        - support for extpict unicode property, added in Ruby 2.6
        - support for 10 unicode script/block properties added in Ruby 3.2

    - rubocop (Currently installed: 1.52.0): https://github.com/rubocop/rubocop/blob/master/CHANGELOG.md
        ## 1.52.1 (2023-06-12)

        ### Bug fixes

        * [#11944](https://github.com/rubocop/rubocop/pull/11944): Fix an incorrect autocorrect for `Style/SoleNestedConditional` with `Style/MethodCallWithArgsParentheses`. ([@koic][])
        * [#11930](https://github.com/rubocop/rubocop/pull/11930): Fix exception on `Lint/InheritException` when class definition has non-constant siblings. ([@rafaelfranca][])
        * [#11919](https://github.com/rubocop/rubocop/issues/11919): Fix an error for `Lint/UselessAssignment` when a variable is assigned and unreferenced in `for`. ([@koic][])
        * [#11928](https://github.com/rubocop/rubocop/pull/11928): Fix an incorrect autocorrect for `Lint/AmbiguousBlockAssociation`. ([@koic][])
        * [#11915](https://github.com/rubocop/rubocop/pull/11915): Fix a false positive for `Lint/RedundantSafeNavigation` when `&.` is used for `to_s`, `to_i`, `to_d`, and other coercion methods. ([@lucthev][])

        ### Changes

        * [#11942](https://github.com/rubocop/rubocop/pull/11942): Require Parser 3.2.2.3 or higher. ([@koic][])

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
