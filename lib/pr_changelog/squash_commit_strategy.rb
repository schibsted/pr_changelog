
# frozen_string_literal: true

module PrChangelog
  # Todo
  class SquashCommitStrategy < BaseCommitStrategy
    SQUASH_COMMIT_FORMAT = /^GitHub: (?<title>[^(]+) \((?<pr_number>#\d+)\)$/.freeze
    TAGGED_TITLE = /^(?<tag>.+):\s*(?<title>.+)$/.freeze

    attr_reader :base_ref, :current_ref, :git_proxy

    def initialize(base_ref, current_ref, git_proxy = GitProxy.new)
      @base_ref    = base_ref
      @current_ref = current_ref
      @git_proxy   = git_proxy
    end

    def parsed_commits
      commits_not_merged_into_base_ref
        .split('- ')
        .reject(&:empty?)
        .map { |e| e.split("\n") }
        .map(&:first)
        .select { |line| line.match(SQUASH_COMMIT_FORMAT) }
    end

    def format_commit(commit_line)
      pr_number = pull_request_number_for(commit_line)
      commit_title = pull_request_title_for(commit_line)
      commit_title.strip!
      # match = commit_title.match(TAGGED_TITLE)
      # if match
        # ChangeLine.new(pr_number, match[:tag], match[:title])
      # else
        ChangeLine.new(pr_number, nil, commit_title)
      # end
    end

    private

    def commits_not_merged_into_base_ref
      git_proxy.commits_between(base_ref, current_ref)
    end

    def pull_request_number_for(github_commit_title)
      md = github_commit_title.match(SQUASH_COMMIT_FORMAT)
      md[:pr_number] if md
    end

    def pull_request_title_for(github_commit_title)
      md = github_commit_title.match(SQUASH_COMMIT_FORMAT)
      md[:title] if md
    end
  end
end
