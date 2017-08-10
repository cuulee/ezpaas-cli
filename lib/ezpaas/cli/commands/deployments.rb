require 'thor'
require 'git'
require 'tmpdir'
require 'tty'
require 'uri'
require 'ezpaas/cli/commands/server_commands'
require 'ezpaas/http/sse_client'

module EzPaaS
  module CLI
    module Commands
      class Deployments < ServerCommands

        desc 'push', 'Pushes the current git repository'
        option :app, :type => :string, :required => true
        option :dir, :type => :string, :default => Dir.pwd
        option :branch, :type => :string, :default => 'master'
        def push
          pastel = Pastel.new

          app = options[:app]
          dir = options[:dir]
          branch = options[:branch]

          puts 'Opening git repository at ' + pastel.blue(dir)
          git = Git.open(dir)
          branch = git.branches[branch]

          begin
            path = Dir::Tmpname.create('ezpaas') do |file|
              puts 'Archiving ' + pastel.blue(branch) + ' branch'
              branch.archive(file, {format: 'tar'})
            end

            url_str = URI::join(options[:server], "proxy/#{app}/").to_s
            success_msg = pastel.green('Application deployment completed')
            success_msg += "\n" + 'Access your application at ' + pastel.blue(url_str)

            server_comm_wrap(success_msg) do
              sse_client.deploy(app, path) do |message|
                puts message
              end
            end

          ensure
            File.delete(path)
          end
        end

        desc 'destroy', 'Scales all processes of an EzPaas app to zero'
        option :app, :type => :string, :required => true
        def destroy
          pastel = Pastel.new
          prompt = TTY::Prompt.new

          app = options[:app]

          puts
          puts '🚨  🚨  🚨   ' + pastel.red("WARNING: You're about to take this app down. People won't be able to access it until you scale it up again.") + '   🚨  🚨  🚨'
          puts

          if prompt.yes?('Are you sure?', default: false)
            success_msg = pastel.green('Application scaling completed')
            server_comm_wrap(success_msg) do
              sse_client.destroy(app) do |message|
                puts message
              end
            end
          else
            puts
            puts pastel.blue('Phew!') + ' App scaling aborted.'
          end


        end

        desc 'scale [<process=count>...]', 'Scales the processes of an EzPaas app'
        option :app, :type => :string, :required => true
        def scale(*scales)
          pastel = Pastel.new

          app = options[:app]

          if scales.empty?
            raise 'You must provide scaling arguments'
          end

          new_scale = {}

          scales.each do |s|
            components = s.split '='
            raise 'Invalid scale format' unless components.count == 2 and components.first.is_a? String and (components.last.to_i.to_s == components.last) and components.last.to_i >= 0
            new_scale[components.first] = components.last.to_i
          end

          puts

          success_msg = pastel.green('Application scaling completed')

          server_comm_wrap(success_msg) do
            sse_client.scale(app, new_scale) do |message|
              puts message
            end
          end
        end

        private

        no_commands do
          def sse_client
            HTTP::SSEClient.new(options[:server])
          end

          def server_comm_wrap(end_msg)
            screen = TTY::Screen.new
            msg = 'Opening connection to slug compilation container'
            puts msg
            puts '─' * [msg.length, screen.width].min
            puts
            yield
            puts
            puts '─' * [end_msg.length, screen.width].min
            puts end_msg
          end
        end


      end
    end
  end
end
