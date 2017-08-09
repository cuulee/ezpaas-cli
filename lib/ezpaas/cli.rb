require 'Thor'

require 'ezpaas/cli/version'
require 'ezpaas/cli/commands/apps'
require 'ezpaas/cli/commands/deployments'

module EzPaaS
  module CLI
  	class Main < Thor
  		
  		desc 'apps', 'Manage apps registered with the EzPaaS server'
  		subcommand 'apps', Commands::Apps

  		desc 'deployments', 'Manage code deployments for your apps'
  		subcommand 'deployments', Commands::Deployments

  	end
  end
end