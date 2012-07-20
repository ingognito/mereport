class Scanner
  attr_reader :heads

  def initialize(github, user, repo)
    @user = user
    @repo = repo
    @github = github
    @branches = branches
    @heads = @branches.inject({}) { |r,branch| r.merge branch[1] => branch[0] }
  end

  def branches
    @branches || @github.repos.branches(@user, @repo).inject({}) do |r,branch|
      r.merge branch.name => branch.commit.sha
    end
  end

  def recurse(sha, options = {})
    depth = options.delete(:depth) || 10
    depth_recurse(sha, depth, options)
  end
  
  private  
  def depth_recurse(sha, depth, options)
    sha = sha.sha if sha.respond_to?(:sha)
    return [] unless depth > 0 && sha != nil && sha != options[:target]
    
    commit = @github.git_data.commits.get(@user, @repo, sha)
    return [] if options[:until] && options[:until].to_i > Time.parse(commit.committer[:date]).to_i
    
    rv = []
    next_on_branch = commit.parents.first
    if commit.parents.length > 1
      merge = if commit.message =~ /Merge pull request #([0-9]+) from (.*)/
        PullCommit.new(commit, @github, @user, @repo, $1, $2)
      else
        MergeCommit.new(commit, @user, @repo)
      end
      commit.parents[1..-1].each do |parent|
        merge.merges << parent
      end     
      rv << merge
    else
      rv << Commit.new(commit, @user, @repo)
    end
    
    rv + depth_recurse(next_on_branch, depth - 1, options)
  end
end
