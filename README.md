# PR Changelog

[![Gem Version](https://badge.fury.io/rb/pr_changelog.svg)](https://badge.fury.io/rb/pr_changelog)

A script to generate a nice list of changes given two git references, like so:

```markdown
## Changes since 0.3.0 to 0.5.0

[New features]
  - #61: ⭐️ Shake the phone to send feedback email

[Improvements]
  - #64: 💎 Visual refinements for canvas 2.0
  - #57: 💎 Memory performance tweaks
  - #62: 💎 Visual polishing for top stories

[Internal]
  - #65: 👨‍💻 Add formatting rules for xml files
  - #60: 👨‍💻 Setup hockeyapp for crash reporting
```

It takes in account all the merged pull request to master between the two given references, then it formats it in a nice consumable way.

To be effective, this script requires that you follow simple conventions:

1. Your pull request titles must be written as changelog entries
2. (Optional) Your project has git tags for each version you release (example: `0.3.0`)
3. (Optional) Your pull request titles begin with some sort of tag (`Feature`, `Improvement`, `Fix`, `Internal`)

Then a sample pull request title would be:

> Feature: shake the phone to send feedback email

This project itself is using this PR convention and the changelog generated with it can be found in https://github.com/schibsted/pr_changelog/releases

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pr_changelog'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install pr_changelog
```

## Usage

To get the changes between to git tags `0.3.0` and `0.5.0`, execute:

```
$ pr_changelog 0.3.0 0.5.0
```

Will produce something like:

```markdown
## Changes from 0.3.0 to 0.5.0

- #64: Improvement: visual refinements for canvas 2.0
- #65: Internal: add formatting rules for xml files
- #63: Feature: add Footer story
- #57: Improvement: memory performance tweaks
- #61: Feature: shake the phone to send feedback email
- #62: Improvement: visual polishing for top stories
- #60: Internal: setup hockeyapp for crash reporting
```

or

```
$ pr_changelog --format pretty 0.3.0 0.5.0
```

Will produce:

```markdown
## Changes since 0.3.0 to 0.5.0

[New features]
  - #61: ⭐️ Shake the phone to send feedback email

[Improvements]
  - #64: 💎 Visual refinements for canvas 2.0
  - #57: 💎 Memory performance tweaks
  - #62: 💎 Visual polishing for top stories

[Internal]
  - #65: 👨‍💻 Add formatting rules for xml files
  - #60: 👨‍💻 Setup hockeyapp for crash reporting
```

It's also possible to not pass any git references if you have sorted git tags. For example, if currently in your project you have the following tags:

```
$ git tag -l
0.1.0
0.1.1
0.2.0
0.2.1
0.2.2
```

Then you can get the changes from the last release to `'master'` with:

```
$ pr_changelog

## Changes since 0.2.2 to master

...
```

If you want to get the changes for the last release (between `0.2.1` and `0.2.2`) you can execute:

```
$ pr_changelog --last-release

## Changes since 0.2.1 to 0.2.2

...
```




## Configuration

Change the emojis or add your own in a `.pr_changelog.json` file:

```json
{
  "tags": [
    {
      "prefix": "feature",
      "emoji": "⭐️",
      "title": "New features"
    },
    {
      "prefix": "improvement",
      "emoji": "💎",
      "title": "Improvements"
    },
    {
      "prefix": "unclassified",
      "emoji": "❓",
      "title": "Unclassified"
    }
  ]
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schibsted/pr_changelog. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `pr_changelog` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/schibsted/pr_changelog/blob/master/CODE_OF_CONDUCT.md).
