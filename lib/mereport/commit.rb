require 'time'

class Commit
  attr_reader :commit
  def initialize(commit, user, repo)
    @commit = commit
    @user = user
    @repo = repo
  end

  def merged?
    false
  end
  
  def pull?
    false
  end

  def sha
    @commit.sha
  end

  def commited_at
    Time.parse(@commit.committer[:date])    
  end
  
  def url
    "https://github.com/#{@user}/#{@repo}/commit/#{id}"
  end
  
  def id
    commit.sha.slice(0,7)
  end

  def who
    commit.author.name
  end

  def title
    commit.message.split('\n').first.chomp
  end

  def date_line
    "Commited at #{commited_at}"
  end

  def body
    commit.message
  end

  def links(regex = %r(https?://[-.a-zA-Z0-9_/]*))
    body.scan regex if regex    
  end

  def long_message
    date_line + "\n" + commit.message
  end
  
  def to_s
    "#{id}: #{title} (#{url}) [#{who}]"
  end
end