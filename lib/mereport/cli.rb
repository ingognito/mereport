
module MergeReport
  class CommandLine 
    attr_accessor :login, :password, :user, :repository, :revision 
    attr_accessor :options  
    def initialize()
      @options = {}
    end
    def self.parse(args)
      options = CommandLine.new
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: mereport [options]"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-l", "--login LOGIN", "GitHub LOGIN") do |user|
          options.login = user
        end

        opts.on("-p", "--password PASSWORD", "GitHub PASSWORD") do |pwd|
          options.password = pwd
        end

        opts.on("-u", "--user USER", "GitHub USER's repository") do |user|
          options.user = user
        end

        opts.on("-r", "--repository REPOSITORY", "GitHub REPOSITORY") do |repo|
          options.repository = repo
        end 

        opts.on("-R", "--revisions SHA", "GitHub SHA to end with") do |revision|
          options.revision = revision
        end 

        opts.on("-T", "--target-revisions SHA", "GitHub SHA to end with") do |revision|
          options.options[:target] = revision
        end 

        opts.on("-D", "--depth DEPTH", "GitHub SHA to end with") do |depth|
          options.options[:depth] = depth.to_i
        end 

      end
      opts.parse(args)
      options
    end
  end
end