require 'excon'
require 'ezpaas/http/http_client'
require 'ezpaas/http/sse/event_source'

module EzPaaS
  module HTTP
    class SSEClient < HTTPClient

      attr_reader :connection

      # Deployments

      def deploy(app, file_name)
        begin
          file = File.open(file_name, 'rb')

          path = "/deployments?app=#{app}"
          url = url_for(path)

          source = SSE::EventSource.new
          source.json = false

          streamer = lambda do |chunk, remaining_bytes, total_bytes|
          	source.feed chunk
          end

          headers = {'Content-Type': 'application/tar'}

          source.on :message do |event|
          	puts event
          end

          Excon.post(url, {:body => file, :response_block => streamer, :headers => headers})

        ensure
          file.close
        end
      end

    end
  end
end
