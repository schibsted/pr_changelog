# frozen_string_literal: true

module PrChangelog
  # Used for the implementation of the exposed executable for this gem
  class CLI
    HELP_TEXT = <<~HELP
      Usage: pr_changelog [options] from_reference to_reference

      [Options]

        -h, --help\tShow this help
        -l, --last-release\tSets from_reference and to_reference to the last release and the previous one
        --format FORMAT_NAME\t(default "plain"), options ("pretty", "plain")
        --strategy STRATEGY_NAME\tIs the strategy used to merge pull requests (default "merge"), options ("merge", "squash").

      [Examples]

        Listing the unreleased changes

        $ pr_changelog

        Listing the changes from the last release

        $ pr_changelog --last-release

        Listing the changes between two given git references

        $ pr_changelog reference_A reference_B
    HELP

    class InvalidInputs < StandardError
    end

    class HelpWanted < StandardError
    end

    attr_reader :format, :strategy, :from_reference, :to_reference

    class CannotDetermineRelease < StandardError
    end

    def initialize(raw_args, releases = nil)
      args = Args.new(raw_args)
      raise HelpWanted if args.include_flags?('-h', '--help')

      @format = args.value_for('--format') || PrChangelog.config.default_format

      @strategy = args.value_for('--strategy') || PrChangelog.config.default_strategy

      @releases = releases || Releases.new

      @from_reference, @to_reference = args.last(2)
      @from_reference ||= @releases.last_release
      @to_reference ||= 'master'

      if args.include_flags?('-l', '--last-release')
        last_release_pair = @releases.last_release_pair
        raise CannotDetermineRelease if last_release_pair.length != 2

        @from_reference, @to_reference = last_release_pair
      end

      return if @from_reference && @to_reference

      raise InvalidInputs
    end

    def build_strategy
      if strategy == 'merge'
        MergeCommitStrategy.new(from_reference, to_reference)
      elsif strategy == 'squash'
        SquashCommitStrategy.new(from_reference, to_reference)
      else
        raise "Strategy '#{strategy}' not recognized."
      end
    end

    def run
      changes = NotReleasedChanges.new(build_strategy)
      puts "## Changes since #{from_reference} to #{to_reference} (#{strategy})\n\n"

      if format == 'pretty'
        puts changes.grouped_formatted_changelog
      else
        puts changes.formatted_changelog
      end
    end
  end
end
