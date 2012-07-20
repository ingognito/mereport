
class MergeCommit < Commit
  attr_accessor :merges
  def initialize(repo, commit)
    super(repo, commit)
    @merges = commit.parents[1..-1]    
  end
  
  def date_line
    "Merged at #{commited_at}"
  end

  def merged?
    true
  end
end