
class PullCommit < MergeCommit
  def initialize(repo, commit, id, branch)
    super(repo, commit)
    @pull_id = id
  end

  def pull
    @pull ||= @repo.pull(@pull_id)
  end

  def pull?; true; end
  
  def body
    pull[:body]
  end
  
  def id
    "\##{@pull_id}"
  end
  
  def url
    pull.html_url
  end

  def who
    pull.user.login
  end
  
  def title
    pull.title
  end
  
end
