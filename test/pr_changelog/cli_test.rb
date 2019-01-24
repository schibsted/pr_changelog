# frozen_string_literal: true

require 'test_helper'

class CLITest < Minitest::Test
  class TestReleases
    def last_release
      'v0.3.2'
    end

    def last_release_pair
      ['v0.3.1', 'v0.3.2']
    end
  end

  class TestInvalidReleases
    def last_release
      nil
    end

    def last_release_pair
      []
    end
  end

  def test_command_with_no_references
    args = []
    test_releases = TestReleases.new
    cli = PrChangelog::CLI.new(args, test_releases)

    assert_equal 'v0.3.2', cli.from_reference
    assert_equal 'master', cli.to_reference
  end

  def test_command_with_one_reference
    args = ['v0.3.0']
    cli = PrChangelog::CLI.new(args)

    assert_equal 'v0.3.0', cli.from_reference
    assert_equal 'master', cli.to_reference
  end

  def test_command_with_two_references
    args = ['v0.3.0', 'v0.3.2']
    cli = PrChangelog::CLI.new(args)

    assert_equal 'v0.3.0', cli.from_reference
    assert_equal 'v0.3.2', cli.to_reference
  end

  def test_passing_a_format_value
    args = ['--format', 'pretty', 'v0.3.1', 'v0.3.2']

    cli = PrChangelog::CLI.new(args)

    assert_equal 'pretty', cli.format
  end
end
