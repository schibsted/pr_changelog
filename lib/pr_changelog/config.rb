# frozen_string_literal: true

require 'json'

module PrChangelog
  # Loads the configuration
  module Config
    @file = '.pr_changelog.json'

    DEFAULTS = [
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
    ].freeze

    def self.load
      if File.exist?(@file)
        JSON.parse(File.read(@file), symbolize_names: true)[:tags]
      else
        DEFAULTS
      end
    end

    def self.file=(file)
      @file = file
    end

    def self.file
      @file
    end
  end
end
