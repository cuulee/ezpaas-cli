require 'thor'
require 'ezpaas/cli/commands/server_commands'

module EzPaaS
  module CLI
    module Commands
      class Deployments < ServerCommands

        desc 'push', 'Pushes the current git repository '
        def list
          puts 'hey'
        end

        desc 'destroy', 'Lists all apps registered with the EzPaaS server'
        def list
          puts 'hey'
        end

        desc 'scale', 'Lists all apps registered with the EzPaaS server'
        def list
          puts 'hey'
        end

      end
    end
  end
end
