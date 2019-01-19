# frozen_string_literal: true

require 'test_helper'

class ConfigTest < Minitest::Test
  def setup
    @original_configuration_file = PrChangelog::Config.file
  end

  def teardown
    PrChangelog::Config.file = @original_configuration_file
  end

  def test_load_defaults
    PrChangelog::Config.file = 'DOES_NOT_EXIST'

    assert_equal Array, PrChangelog::Config.load.class
    assert_equal 5, PrChangelog::Config.load.length
  end

  def test_load_file
    PrChangelog::Config.file = 'test/sample_data/pr_changelog_config.json'

    assert_equal Array, PrChangelog::Config.load.class
    assert_equal 1, PrChangelog::Config.load.length
  end
end
