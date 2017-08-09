require 'thor'
require 'ezpaas/client'

module EzPaaS
  module CLI
    module Commands
      class ServerCommands < Thor
        
        class_option :server, :type => :string, :banner => '<server url>', :default => 'http://127.0.0.1:3000'
        
        no_commands do
          def client
          	Client.new(options[:server])
          end
        end

      end
    end
  end
end
