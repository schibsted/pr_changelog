# frozen_string_literal: true

module PrChangelog
  class GitProxy
    LOG_FORMAT = '- %cn: %s%n%w(80, 2, 2)%b'

    def merge_commits_between(base_ref, current_ref)
      `git log --merges #{base_ref}..#{current_ref} --format='#{LOG_FORMAT}'`
    end
  end
end
