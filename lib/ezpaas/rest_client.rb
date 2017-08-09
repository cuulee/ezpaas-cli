require 'httparty'
require 'uri'

module EzPaaS
  class RESTClient

    class RestError < StandardError
    end

    include HTTParty

    attr_reader :url

    def initialize(url)
      @url = url
    end

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

    def url_for(path)
      URI::join(url, path)
    end

    def handle(response)
      if response.code >= 400
        raise ClientError, (response['error'] || 'An unknown error occurred.')
      else
        response
      end
    end

  end
end
end
