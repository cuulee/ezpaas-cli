require 'thor'
require 'git'
require 'tmpdir'
require 'ezpaas/cli/commands/server_commands'
require 'ezpaas/http/sse_client'

module EzPaaS
  module CLI
    module Commands
      class Deployments < ServerCommands

        desc 'push', 'Pushes the current git repository '
        option :dir, :type => :string, :default => Dir.pwd
        option :branch, :type => :string, :default => 'master'
        option :app, :type => :string
        def push
          git = Git.open(options[:dir])
          branch = git.branches[options[:branch]]
          begin
            path = Dir::Tmpname.create('ezpaas') do |file|
              branch.archive(file, {format: 'tar'})
            end
            sse_client.deploy('inept-florio', path)
          ensure
            File.delete(path)
          end
        end

        desc 'destroy', 'Lists all apps registered with the EzPaaS server'
        def destroy
          puts 'hey'
        end

        desc 'scale', 'Lists all apps registered with the EzPaaS server'
        def scale
          puts 'hey'
        end

        private

        no_commands do
          def sse_client
            HTTP::SSEClient.new(options[:server])
          end
        end

      end
    end
  end
end
