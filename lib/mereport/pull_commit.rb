
class PullCommit < MergeCommit
  attr_reader :pull
  def initialize(commit, github, user, repository, pull_id, pull_branch)    
    super(commit, user, repository)
    @pull_id = pull_id
    @pull = github.pull_requests.get(user, repository, pull_id)
  end
  
  def pull?; true; end
  
  def body
    @pull[:body]
  end
  
  def id
    "\##{@pull_id}"
  end
  
  def url
    pull.html_url
  end

  def who
    @pull.user.login
  end
  
  def title
    @pull.title
  end
  
end
