$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

require 'mereport'
require 'mereport/cli'
require 'mereport/browser'

require 'github_api'

def format_title(msg)
  puts
  puts msg
  puts '=' * msg.length
end

options = MergeReport::CommandLine.parse(ARGV)

github = Github.new(login: options.login, password: options.password)

repo = Repository.new(github, options.user, options.repository)
if options[:actions].include? :merge or options[:actions].include? :commits
  commit = repo.commit(options.revision || repo.branches['master'])
  other = []

  if options[:actions].include? :merge
    format_title "Pull requests merged since #{options[:until] || options[:target]}"
  end

  links = []
  while commit && commit.sha != options[:target] && (options[:until] || 0).to_i < commit.commited_at.to_i
    if commit.respond_to?(:pull)
      if options[:actions].include? :merge
        puts "* #{commit}"
        puts "  #{commit.date_line}"
        links << commit.url
        if options.links
          commit.links(%r(https?://[-.a-zA-Z0-9_/]*#{options.links}[-.a-zA-Z0-9_/]*)).each do |link|
            puts "  - #{link}"
            links << commit.links
          end
        end
      end
    else
      other << commit
    end
    commit = commit.next    
  end
  if !links.empty? && options.open_in_browser
    open_in_browser(links)
    links = []
  end
  if !other.empty? and options[:actions].include? :commits
    format_title "Other commits to master since #{options[:until] || options[:target]}"
    other.each do |c|
      puts "* #{c}"
      puts "  #{c.date_line}"
      links << c.url
      c.links(%r(https?://[-.a-zA-Z0-9_/]*#{options.links}[-.a-zA-Z0-9_/]*)).each do |link|
        puts "  - #{link}"
        links << link
      end
    end
  end
  if !links.empty? && options.open_in_browser
    open_in_browser(links)
  end
end

if options[:actions].include? :pull
  pulls = repo.pulls
  format_title "There are #{pulls.length} open pull requests"
  links = []
  pulls.each do |req|
    puts "* #{req.number}: #{req.title} (#{req.html_url}) [#{req.user.login}]"
    links << req.html_url
  end
  if !links.empty? && options.open_in_browser
    open_in_browser(links)
  end

  if options[:actions].include? :actions

    format_title "Action list"
    pulls.each do |req|  
      comments = repo.comments(req)
      last_comment = nil
      comments.each do |comment|    
        unless last_comment && Time.parse(last_comment.updated_at) > Time.parse(comment.updated_at)
          last_comment = comment
        end
      end
      print "* \##{req.number}"
      if last_comment
        print " #{last_comment.user.login}: #{(last_comment['body'] || '').split("\n").first.chomp}"
      else
        print ' under review'
      end
      puts
    end
  end
end