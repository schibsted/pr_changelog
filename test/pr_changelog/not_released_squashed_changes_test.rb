# frozen_string_literal: true

require 'test_helper'

class NotReleasedSquashedChangesTest < Minitest::Test
  class TestGit
    def commits_between(_from_ref, _to_ref)
      File.readlines('test/sample_data/raw_squash_log.txt').join('').chomp
    end
  end

  attr_reader :changes

  def setup
    test_git = TestGit.new
    strategy = PrChangelog::SquashCommitStrategy.new('0.3.0', '0.5.0', test_git)
    @changes = PrChangelog::NotReleasedChanges.new(strategy)
  end

  def test_plain_format
    sample_plain_changelog = lines_from_file(
      'test/sample_data/plain_format_squash.txt'
    )
    assert_equal sample_plain_changelog, changes.formatted_changelog
  end

  def test_pretty_format
    sample_pretty_changelog = lines_from_file(
      'test/sample_data/pretty_format_squash.txt'
    )

    assert_equal sample_pretty_changelog, changes.grouped_formatted_changelog
  end

  private

  def lines_from_file(file_name)
    File.readlines(file_name).join('').chomp
  end
end
