# frozen_string_literal: true

require 'test_helper'

class ConfigTest < Minitest::Test
  def test_default_tags
    config = PrChangelog::Config.new('DOES_NOT_EXIST')

    assert_equal Array, config.tags.class
    assert_equal 5, config.tags.length
  end

  def test_load_tags_from_file
    config = PrChangelog::Config.new(
      'test/sample_data/pr_changelog_config.json'
    )

    assert_equal Array, config.tags.class
    assert_equal 1, config.tags.length
  end
end
