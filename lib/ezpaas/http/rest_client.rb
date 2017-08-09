require 'httparty'
require 'ezpaas/http/http_client'

module EzPaaS
  module HTTP
    class RESTClient < HTTPClient

      include HTTParty

      # Apps

      def apps
        (handle self.class.get(url_for('/apps')))['apps']
      end

      def create_app(name)
        options = {
          body: {
            name: name
          }
        }
        handle self.class.post(url_for('/apps'), options)
      end

      def destroy_app(name)
        options = {
          query: {
            name: name
          }
        }
        handle self.class.delete(url_for('/apps'), options)
      end

      private

      def handle(response)
        if response.code >= 400
          raise HTTPError, (response['error'] || 'An unknown error occurred.')
        else
          response
        end
      end

    end
  end
end
