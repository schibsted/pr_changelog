# frozen_string_literal: true

module PrChangelog
  # Calculates a list of not released changes from `base_ref` to `current_ref`
  # those changes consist of the merged pull-request title
  class NotReleasedChanges
    attr_reader :commits_strategy

    def initialize(commits_strategy)
      @commits_strategy = commits_strategy
    end

    def emoji_tags
      tags = {}

      PrChangelog.config.tags.each_with_index do |item, index|
        tags[item[:prefix]] = Tag.new(item[:emoji], item[:title], index)
      end

      tags
    end

    def formatted_changelog
      if parsed_change_list.count.positive?
        parsed_change_list.map(&:to_s).join("\n")
      else
        no_changes_found
      end
    end

    def grouped_formatted_changelog
      if parsed_change_list.count.positive?
        GroupedChanges.new(parsed_change_list, emoji_tags).to_s
      else
        no_changes_found
      end
    end

    private

    def no_changes_found
      'No changes found'
    end

    def parsed_change_list
      @parsed_change_list ||= commits_strategy.parsed_commits.map do |commit_info|
        commits_strategy.format_commit(commit_info)
      end
    end
  end
end
