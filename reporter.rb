$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

require 'mereport'
require 'mereport/cli'

require 'github_api'

def format_title(msg)
  puts
  puts msg
  puts '=' * msg.length
end

options = MergeReport::CommandLine.parse(ARGV)

github = Github.new(login: options.login, password: options.password)
scanner =  Scanner.new(github, options.user, options.repository)

if options[:actions].include? :merge or options[:actions].include? :commits
  report = scanner.recurse(scanner.branches['master'], options.options)

  if options[:actions].include? :merge
    format_title "Pull requests merged since #{options[:until] || options[:target]}"
    report.each do |c|
      next unless c.pull?
      puts "* #{c}"
      puts "  #{c.date_line}"
      c.links.each do |link|
        puts "  - #{link}"
      end
    end
  end

  if options[:actions].include? :commits
    format_title "Other commits to master since #{options[:until] || options[:target]}"
    report.each do |c|
      next if c.pull?
      puts "* #{c}"
      puts "  #{c.date_line}"
      c.links(%r(https?://[-.a-zA-Z0-9_/]*#{options.links}[-.a-zA-Z0-9_/]*)).each do |link|
      puts "  - #{link}"
    end
  end
end
end

if options[:actions].include? :pull
  pulls = github.pull_requests.list('kreuzwerker', 'AIDA.WL.App')
  format_title "There are #{pulls.length} open pull requests"
  pulls.each do |req|
    puts "* #{req.number}: #{req.title} (#{req.html_url}) [#{req.user.login}]"
  end

  if options[:actions].include? :actions

    format_title "Action list"
    pulls.each do |req|  
      comments = github.pull_requests.comments.list options.user, options.repository, req.number
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