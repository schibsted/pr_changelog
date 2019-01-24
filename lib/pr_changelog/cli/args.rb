# frozen_string_literal: true

module PrChangelog
  class CLI
    # A simple wrapper over ARGV that is passed to the CLI class
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
  end
end
