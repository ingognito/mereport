require 'time'

class Commit
  attr_reader :commit

  def initialize(repo, commit)
    @repo = repo
    @commit = commit
  end
  
  def next
    @repo.commit(@commit.parents.first.sha) unless @commit.parents.empty?
  end

  def sha
    @commit.sha
  end

  def commited_at
    Time.parse(@commit.committer[:date])    
  end
  
  def url
    "#{@repo.url}/commit/#{id}"
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