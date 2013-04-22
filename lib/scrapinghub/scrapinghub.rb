require_relative 'api_method'

module Scrapinghub
  class Scrapinghub
    METHODS = {
      projects:   ApiMethod.new('scrapyd/listprojects', []),
      spiders:    ApiMethod.new('spiders/list', [:project])
    }

    attr_reader :api_key

    def initialize(api_key, url='http://panel.scrapinghub.com/api/')
      @api_key = api_key
      @base_url = url
    end

    def get(method)
      if method.is_a? Symbol
        api_method = get_method_url(method)
      else
        api_method = build_url(method)
      end

      (uri, parameters) = api_method

      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth @api_key, ''

        http.request request
      end
    end

    def method_missing(method, *args, &block)
      if METHODS[method]
        get(method)
      else
        super
      end
    end

    private
    def build_url(api_method)
      api_method.build(@base_url)
    end

    def get_method_url(method)
      api_method = METHODS[method]

      return build_url(api_method)
    end
  end
end

