
module MergeReport
  class CommandLine 
    attr_accessor :login, :password, :user, :repository, :revision , :links, :open_in_browser
    attr_accessor :options  
    def initialize()
      @options = {actions: [:merge, :commits]}
    end
    
    def [](key)
      @options[key] # || self.respond_to?(key) ? self.send(key) : nil
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

        opts.on("-R", "--revisions SHA", "GitHub SHA to start with") do |revision|
          options.revision = revision
        end 

        opts.on("-T", "--target-revisions SHA", "GitHub SHA to end with") do |revision|
          options.options[:target] = revision
        end 

        opts.on("-D", "--depth DEPTH", "Depth used for backtracking") do |depth|
          options.options[:depth] = depth.to_i
        end 

        opts.on("-s", "--since TIME", "Show only commits prior to TIME") do |time|
          options.options[:until] = Time.parse(time)
        end 

        opts.on('-L', '--links LINKS', 'scans for LINKS') do |links|
          options.links = links
        end

        opts.on( '-m', '--[no-]merge', "Show/don't show merge reports (default: on)" ) do |n|
          if n
            options.options[:actions] << :merge
          else
            options.options[:actions].delete(:merge)
          end
        end

        opts.on( '-c', '--[no-]commits', "Show/don't show commits to master (default: on)" ) do |n|
          if n
            options.options[:actions] << :commits
          else
            options.options[:actions].delete(:commits)
          end
        end

        opts.on( '-P', '--[no-]pull', "Show/don't show pull requests (default: off)" ) do |n|
          if n
            options.options[:actions] << :pull
          else
            options.options[:actions].delete(:pull)
          end
        end

        opts.on( '-a', '--[no-]actions', "Show/don't show actions  (default: off)" ) do |n|
          if n
            options.options[:actions] << :actions
          else
            options.options[:actions].delete(:actions)
          end
        end

        opts.on( '-b', '--[no-]browser', "Open all links in new browser window. Only works under OS X.  (default: off)" ) do |n|
          options.open_in_browser = n
        end

      end
      opts.parse(args)
      options
    end
  end
end