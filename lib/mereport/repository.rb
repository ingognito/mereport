
require 'github_api'

class Repository
  attr_reader :user, :repository
  def initialize(github, user, repo)
    @github = github
    @user = user
    @repo = repo
  end
  
  def url
    "https://github.com/#{@user}/#{@repo}"    
  end
  
  def branches
    @branches || @github.repos.branches(@user, @repo).inject({}) do |r,branch|
      r.merge branch.name => branch.commit.sha
    end
  end
  
  def pull(id)
    @github.pull_requests.get(@user, @repo, id)
  end

  def pulls
    @github.pull_requests.list(@user, @repo)
  end

  def commit(sha)
    commit = @github.git_data.commits.get(@user, @repo, sha)
    if commit.parents.length > 1
      if commit.message =~ /Merge pull request #([0-9]+) from (.*)/
        PullCommit.new(self, commit, $1, $2)
      else
        MergeCommit.new(self, commit)
      end
    else
      Commit.new(self, commit)
    end
  end

  def comments(pull)
    @github.pull_requests.comments.list @user, @repo, pull.number
  end

end