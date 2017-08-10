require 'excon'
require 'json'
require 'ezpaas/http/http_client'
require 'ezpaas/http/sse/event_source'

module EzPaaS
  module HTTP
    class SSEClient < HTTPClient

      # Deployments

      def deploy(app, file_name)
        begin
          file = File.open(file_name, 'rb')

          path = "/deployments?app=#{app}"

          options = {
            body: file,
            headers: {'Content-Type': 'application/tar'}
          }

          streaming_request(:post, path, options) do |message|
            yield message.data if block_given?
          end
        ensure
          file.close
        end
      end

      def scale(app, scale) 
        scale_qs = scale.map { |k, v| "scale[#{k}]=#{v}" }.join('&')
        path = "/deployments?app=#{app}&" + scale_qs
        streaming_request(:patch, path) do |message|
          yield message.data if block_given?
        end
      end

      def destroy(app) 
        path = "/deployments?app=#{app}"
        streaming_request(:delete, path) do |message|
          yield message.data if block_given?
        end
      end

      private

      def streaming_request(type, path, options = {})
        url = url_for(path)

        source = SSE::EventSource.new

        source.json = false

        streamer = lambda do |chunk, remaining_bytes, total_bytes|
          source.feed chunk
        end

        source.on :message do |event|
          yield event if block_given?
        end

        merged_options = options.merge({ :response_block => streamer })

        Excon.send type, url, merged_options
      end

    end
  end
end
