# frozen_string_literal: true

require 'test_helper'

class ReleasesTest < Minitest::Test
  class TestGit
    attr_reader :expected_tags

    def initialize(expected_tags = nil)
      @expected_tags = expected_tags || ['0.1.0', '0.2.1', '0.2.2', '0.3.0']
    end

    def git_tags_list
      expected_tags
    end
  end

  def test_last_release
    test_git = TestGit.new
    releases = PrChangelog::Releases.new(test_git)

    assert_equal '0.3.0', releases.last_release
  end

  def test_last_release_pair
    test_git = TestGit.new
    releases = PrChangelog::Releases.new(test_git)

    assert_equal ['0.2.2', '0.3.0'], releases.last_release_pair
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
