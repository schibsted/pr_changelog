# frozen_string_literal: true

module PrChangelog
  # Used for the implementation of the exposed executable for this gem
  class CLI

    class Args
      def initialize(raw_args)
        @raw_args = raw_args
      end

      def include?(flag)
        raw_args.include?(flag)
      end

      def value_for(flag)
        return nil unless raw_args.index(flag)

        next_index = raw_args.index(flag) + 1
        value = raw_args.delete_at(next_index)
        raw_args.delete(flag)
        value
      end

      def include_flags?(flag, flag_variation)
        include?(flag) || include?(flag_variation)
      end

      def last(number)
        raw_args.last(number)
      end

      attr_reader :raw_args
    end

    HELP_TEXT = <<~HELP
      Usage: pr_changelog [options] from_reference to_reference

      [Options]

        -h, --help\tShow this help
        --format FORMAT_NAME\t(default "plain"), options ("pretty", "plain")

      [Examples]

        Listing the unreleased changes

        $ pr_changelog
    HELP

    class InvalidInputs < StandardError
    end

    class HelpWanted < StandardError
    end

    attr_reader :format, :from_reference, :to_reference


    def initialize(raw_args, releases = nil)
      args = Args.new(raw_args)
      raise HelpWanted.new if args.include_flags?('-h', '--help')

      @format = args.value_for('--format') || PrChangelog.config.default_format

      @releases = releases || Releases.new

      @from_reference, @to_reference = args.last(2)
      @from_reference ||= @releases.last_release
      @to_reference ||= 'master'

      return if @from_reference && @to_reference

      raise InvalidInputs.new
    end

    def run
      changes = NotReleasedChanges.new(from_reference, to_reference)
      puts "## Changes since #{from_reference} to #{to_reference}\n\n"

      if format == 'pretty'
        puts changes.grouped_formatted_changelog
      else
        puts changes.formatted_changelog
      end
    end
  end
end
