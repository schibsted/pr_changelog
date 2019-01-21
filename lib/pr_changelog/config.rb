# frozen_string_literal: true

require 'json'

module PrChangelog
  # Loads the configuration
  class Config
    DEFAULTS = {
      format: 'plain',
      tags: [
        {
          prefix: 'feature',
          emoji: '⭐️',
          title: 'New features'
        },
        {
          prefix: 'fix',
          emoji: '🐛',
          title: 'Fixes'
        },
        {
          prefix: 'improvement',
          emoji: '💎',
          title: 'Improvements'
        },
        {
          prefix: 'internal',
          emoji: '👨‍💻',
          title: 'Internal'
        },
        {
          prefix: 'unclassified',
          emoji: '❓',
          title: 'Unclassified'
        }
      ]
    }.freeze

    def initialize(file = nil)
      @file = file || '.pr_changelog.json'
      @loaded_data = {}

      return unless File.exist?(@file)

      @loaded_data = JSON.parse(File.read(@file), symbolize_names: true)
    end

    def default_format
      loaded_data[:format] || DEFAULTS[:format]
    end

    def tags
      loaded_data[:tags] || DEFAULTS[:tags]
    end

    private

    attr_reader :loaded_data
  end
end
