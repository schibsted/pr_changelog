# frozen_string_literal: true

require 'test_helper'

class NotReleasedChangesTest < Minitest::Test
  class TestGit
    def merge_commits_between(_from_ref, _to_ref)
      File.readlines('test/sample_data/raw_log.txt').join('').chomp
    end
  end

  attr_reader :test_git, :changes

  def setup
    @test_git = TestGit.new
    @changes = PrChangelog::NotReleasedChanges.new('0.3.0', '0.5.0', test_git)
  end

  def test_plain_format
    sample_plain_changelog = lines_from_file(
      'test/sample_data/plain_format.txt'
    )

    assert_equal changes.formatted_changelog, sample_plain_changelog
  end

  def test_pretty_format
    sample_pretty_changelog = lines_from_file(
      'test/sample_data/pretty_format.txt'
    )

    assert_equal changes.grouped_formatted_changelog, sample_pretty_changelog
  end

  private

  def lines_from_file(file_name)
    File.readlines(file_name).join('').chomp
  end
end

