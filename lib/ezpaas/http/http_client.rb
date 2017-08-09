require 'uri'

module EzPaaS
  module HTTP
    class HTTPClient

      class HTTPError < StandardError
      end

      attr_reader :url

      def initialize(url)
        @url = url
      end

      protected

      def url_for(path)
        URI::join(url, path).to_s
      end

    end
  end
end
