# frozen_string_literal: true

module PrChangelog
  # A strategy that given two references will return the filtered commit changes
  # based on the merge commits
  class MergeCommitStrategy < BaseCommitStrategy
    MERGE_COMMIT_FORMAT = /Merge pull request (?<pr_number>#\d+) .*/.freeze
    TAGGED_TITLE = /^(?<tag>.+):\s*(?<title>.+)$/.freeze

    attr_reader :base_ref, :current_ref, :git_proxy

    def initialize(base_ref, current_ref, git_proxy = GitProxy.new)
      @base_ref    = base_ref
      @current_ref = current_ref
      @git_proxy   = git_proxy
    end

    def parsed_commits
      merge_commits_not_merged_into_base_ref
        .split('- ')
        .reject(&:empty?)
        .map { |e| e.split("\n") }
        .select { |pair| pair.count == 2 }
    end

    def format_commit(commit_info)
      github_commit_title = commit_info.first
      commit_title = commit_info.last

      pr_number = pull_request_number_for(github_commit_title)
      commit_title.strip!
      match = commit_title.match(TAGGED_TITLE)
      if match
        ChangeLine.new(pr_number, match[:tag], match[:title])
      else
        ChangeLine.new(pr_number, nil, commit_title)
      end
    end

    private

    def merge_commits_not_merged_into_base_ref
      git_proxy.merge_commits_between(base_ref, current_ref)
    end

    def pull_request_number_for(github_commit_title)
      md = github_commit_title.match(MERGE_COMMIT_FORMAT)
      md[:pr_number] if md
    end
  end
end
