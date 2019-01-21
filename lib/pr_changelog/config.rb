# frozen_string_literal: true

require 'json'

module PrChangelog
  # Loads the configuration
  class Config
    DEFAULTS = {
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
      @loaded_data = nil

      return unless File.exist?(@file)

      @loaded_data = JSON.parse(File.read(@file), symbolize_names: true)
    end

    def tags
      if loaded_data
        loaded_data[:tags]
      else
        DEFAULTS[:tags]
      end
    end

    private

    attr_reader :loaded_data
  end
end
