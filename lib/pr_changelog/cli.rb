# frozen_string_literal: true

module PrChangelog
  # Used for the implementation of the exposed executable for this gem
  class CLI
    HELP_TEXT = <<~HELP
      Usage: pr_changelog [options] from_reference to_reference

      [Options]

        -h, --help\tShow this help
        --format FORMAT_NAME\t(default "pretty"), options ("pretty", "plain")

      [Examples]

        Listing the changes for the last release (since the previous to the last one)

        $ pr_changelog
    HELP

    attr_reader :format, :from_reference, :to_reference

    def initialize(args)
      @format = 'pretty'
      if args.include?('--format')
        next_index = args.index('--format') + 1
        @format = args.fetch(next_index)
      end
      @from_reference, @to_reference = args.last(2)
    end

    def run
      changes = NotReleasedChanges.new(from_reference, to_reference)
      if format == 'plain'
        puts changes.formatted_changelog
      else
        puts changes.grouped_formatted_changelog
      end
    end
  end
end
