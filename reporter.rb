$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

require 'mereport'
require 'mereport/cli'

require 'github_api'

options = MergeReport::CommandLine.parse(ARGV)

github = Github.new(login: options.login, password: options.password)
scanner =  Scanner.new(github, options.user, options.repository)

scanner.recurse(scanner.branches['master'], options.options).each do |c|
  puts "* #{c}"
  puts "  #{c.date_line}"
  c.links.each do |link|
    puts "  - #{link}"
  end
end
