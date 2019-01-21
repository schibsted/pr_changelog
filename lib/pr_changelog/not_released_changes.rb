# frozen_string_literal: true

module PrChangelog
  # Calculates a list of not released changes from `base_ref` to `current_ref`
  # those changes consist of the merged pull-request title
  class NotReleasedChanges
    MERGE_COMMIT_FORMAT = /Merge pull request (?<pr_number>#\d+) .*/.freeze
    TAGGED_TITLE = /^(?<tag>.+):\s*(?<title>.+)$/.freeze

    attr_reader :base_ref, :current_ref, :git_proxy

    def initialize(base_ref, current_ref, git_proxy = GitProxy.new)
      @base_ref    = base_ref
      @current_ref = current_ref
      @git_proxy   = git_proxy
    end

    def emoji_tags
      tags = {}

      PrChangelog.config.each_with_index do |item, index|
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
      @parsed_change_list ||= parsed_merge_commits.map do |pair|
        format_merge_commit(pair.first, pair.last)
      end
    end

    def parsed_merge_commits
      merge_commits_not_merged_into_base_ref
        .split('- ')
        .reject(&:empty?)
        .map { |e| e.split("\n") }
        .select { |pair| pair.count == 2 }
    end

    def format_merge_commit(github_commit_title, commit_title)
      pr_number = pull_request_number_for(github_commit_title)
      commit_title.strip!
      match = commit_title.match(TAGGED_TITLE)
      if match
        ChangeLine.new(pr_number, match[:tag], match[:title])
      else
        ChangeLine.new(pr_number, nil, commit_title)
      end
    end

    def merge_commits_not_merged_into_base_ref
      git_proxy.merge_commits_between(base_ref, current_ref)
    end

    def pull_request_number_for(github_commit_title)
      md = github_commit_title.match(MERGE_COMMIT_FORMAT)
      md[:pr_number] if md
    end
  end
end
