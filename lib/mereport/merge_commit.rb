
class MergeCommit < Commit
  attr_accessor :merges
  def initialize(commit, user, repo)
    super(commit, user, repo)
    @merges = []
  end
  
  def date_line
    "Merged at #{commited_at}"
  end

  def merged?
    true
  end
end