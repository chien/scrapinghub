require_relative 'api_method'

module Scrapinghub
  class Scrapinghub
    METHODS = {
      projects:       ApiMethod.new('scrapyd/listprojects', []),
      spiders:        ApiMethod.new('spiders/list', [:project]),
      jobs:           ApiMethod.new('jobs/list', [:project]),
      job:            ApiMethod.new('jobs/list', [:project, :job]),
      job_items:      ApiMethod.new('items', [:project, :job]),
      spider_items:   ApiMethod.new('items', [:project, :spider])
    }

    attr_reader :api_key

    def initialize(api_key, url='http://panel.scrapinghub.com/api/')
      @api_key = api_key
      @base_url = url
    end

    def get(method, parameters = {})
      if method.is_a? Symbol
        uri = get_method_url(method, parameters)
      else
        uri = build_url(method, parameters)
      end

      fetch(uri)
    end

    def fetch(uri, redirect_limit = 5)
      if redirect_limit <= 0
        raise "Request redirected too many times."
      end

      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth @api_key, ''

        response = http.request(request)

        case response
        when Net::HTTPFound
          new_location = URI(response['location'])

          debug "<- #{uri.request_uri} redirects to",
                "-> #{new_location.request_uri}"

          fetch(new_location, redirect_limit-1)
        else
          response
        end
      end
    end

    def method_missing(method, *args, &block)
      if METHODS[method]
        get(method, args)
      else
        super
      end
    end

    private
    def build_url(api_method, parameters)
      api_method.build(@base_url, parameters)
    end

    def get_method_url(method, parameters)
      api_method = METHODS[method]

      return build_url(api_method, parameters)
    end

    def debug(*messages)
      puts messages.join("\n")
    end
  end
end

