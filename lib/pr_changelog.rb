# frozen_string_literal: true

require 'pr_changelog/version'
require 'pr_changelog/config'
require 'pr_changelog/extensions/string'
require 'pr_changelog/releases'
require 'pr_changelog/cli/args'
require 'pr_changelog/cli'
require 'pr_changelog/git_proxy'
require 'pr_changelog/tag'
require 'pr_changelog/change_line'
require 'pr_changelog/grouped_changes'
require 'pr_changelog/base_commit_strategy'
require 'pr_changelog/merge_commit_strategy'
require 'pr_changelog/squash_commit_strategy'
require 'pr_changelog/not_released_changes'

# Main module
module PrChangelog
  def self.config
    @config ||= Config.new
  end
end
