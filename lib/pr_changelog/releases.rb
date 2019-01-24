# frozen_string_literal: true

module PrChangelog
  class Releases
    attr_reader :git_proxy

    def initialize(git_proxy = GitProxy.new)
      @git_proxy = git_proxy
    end

    def last_release
      git_proxy.git_tags_list.last
    end

    def last_release_pair
      git_proxy.git_tags_list.last(2)
    end
  end
end
