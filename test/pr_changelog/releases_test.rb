# frozen_string_literal: true

require 'test_helper'

class ReleasesTest < Minitest::Test
  class TestGit
    attr_reader :expected_tags

    def initialize(expected_tags = nil)
      default_tags = [
        '1.10.0',
        '1.10.1',
        '1.11.0',
        '1.12.0',
        '1.12.1',
        '1.7.0',
        '1.7.1',
        '1.8.0',
        '1.9.2',
        '1.9.3'
      ]
      @expected_tags = expected_tags || default_tags
    end

    def git_tags_list
      expected_tags
    end
  end

  def test_last_release
    test_git = TestGit.new
    releases = PrChangelog::Releases.new(test_git)

    assert_equal '1.12.1', releases.last_release
  end

  def test_last_release_pair
    test_git = TestGit.new
    releases = PrChangelog::Releases.new(test_git)

    assert_equal ['1.12.0', '1.12.1'], releases.last_release_pair
  end

  def test_last_release_with_no_tags
    test_git = TestGit.new([])
    releases = PrChangelog::Releases.new(test_git)

    assert_nil releases.last_release
  end

  def test_last_release_pair_with_no_tags
    test_git = TestGit.new([])
    releases = PrChangelog::Releases.new(test_git)

    assert_equal [], releases.last_release_pair
  end
end
