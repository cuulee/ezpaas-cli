require 'thor'
require 'tty'
require 'random-word'
require 'uri'
require 'ezpaas/cli/commands/server_commands'

module EzPaaS
  module CLI
    module Commands
      class Apps < ServerCommands

        desc 'list', 'Lists all apps registered with the EzPaaS server'
        def list
          apps = client.apps

          pastel = Pastel.new
          not_deployed = pastel.red('(not deployed)')

          table = TTY::Table.new(header: ['name', 'slug', 'scale', 'url']) do |t|
            apps.each do |app|

              app_name = app['name']

              app_slug = app['slug']

              url_string = app_slug ? URI::join(options[:server], "proxy/#{app_name}/") : not_deployed

              slug_string = app_slug || not_deployed

              if scale = app['scale']
                scale_string = app['scale'].map{ |k, v| "#{k}=#{v}" }.join('\n')
              else
                scale_string = not_deployed
              end

              t << [app_name, slug_string, scale_string, url_string]
            end
          end

          puts
          puts table.render(:unicode, multiline: true)
        end

        desc 'create', 'Creates a new app on the EzPaaS server'
        option :name, :type => :string, :banner => '<app name>'
        def create
          app_name = options[:name]

          unless app_name
            prompt = TTY::Prompt.new

            default = loop do
              default = "#{RandomWord.adjs(not_longer_than: 10).next}-#{RandomWord.nouns(not_longer_than: 10).next}"
              break default unless default.include?('_')
            end

            app_name = prompt.ask('What would you like to call your new app?', required: true, default: default)
          end

          pastel = Pastel.new

          app = client.create_app(app_name)['app']
          app_name = pastel.blue(app['name'])

          puts
          puts "App #{app_name} created successfully!"
        end

        desc 'destroy', 'Destroys an app on the EzPaaS server'
        option :app, :type => :string, :banner => '<app name>'
        def destroy
          pastel = Pastel.new

          puts
          puts '🚨  🚨  🚨   ' + pastel.red('WARNING: Destroying an app is ') + pastel.red.bold.underline('not') + pastel.red(' reversible!') + '   🚨  🚨  🚨'
          puts

          app_name = options[:app]

          prompt = TTY::Prompt.new

          unless app_name
            apps = client.apps
            app_names = apps.map { |e| e['name'] }
            app_name = prompt.select('Which app would you like to destroy?', app_names)
          end

          if prompt.yes?('Are you sure?', default: false)
            client.destroy_app(app_name)
            puts
            puts "App #{app_name} destroyed successfully!"
          else
            puts
            puts pastel.blue('Phew!') + ' App deletion aborted.'
          end
        end

      end
    end
  end
end
