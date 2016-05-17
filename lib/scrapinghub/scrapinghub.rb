require_relative 'api_method'

module Scrapinghub
  class Scrapinghub
    METHODS = {
      projects:       { http_type: :get, method: ApiMethod.new('scrapyd/listprojects', []) },
      spiders:        { http_type: :get, method: ApiMethod.new('spiders/list', [:project]) },
      jobs:           { http_type: :get, method: ApiMethod.new('jobs/list', [:project]) },
      job:            { http_type: :get, method: ApiMethod.new('jobs/list', [:project, :job]) },
      job_items:      { http_type: :get, method: ApiMethod.new('items', [:project, :job]) },
      spider_items:   { http_type: :get, method: ApiMethod.new('items', [:project, :spider]) },
      schedule:   { http_type: :post, method: ApiMethod.new('schedule', [:project, :spider]) },
    }

    attr_reader :api_key

    def initialize(api_key, url='https://dash.scrapinghub.com/api/', debug_mode=false)
      @api_key = api_key
      @base_url = url
      @debug_mode = debug_mode
    end

    def get(method, parameters = {})
      if method.is_a? Symbol
        uri = get_method_url(method, parameters)
      else
        uri = build_url(method, parameters)
      end

      fetch(uri)
    end

    def post(method, parameters = {})
      if method.is_a? Symbol
        uri = get_method_url(method, parameters)
      else
        uri = build_url(method, parameters)
      end

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new(uri.request_uri)
        request.basic_auth @api_key, ''

        request.add_field('Content-Type', 'application/json')
        request.set_form_data(parameters)
        response = http.request(request)

        ApiResponse.new(response)
      end
    end

    def fetch(uri, redirect_limit = 5)
      if redirect_limit <= 0
        raise "Request redirected too many times."
      end

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth @api_key, ''

        response = http.request(request)

        case response
        when Net::HTTPFound
          new_location = URI(response['location'])

          if @debug_mode
            debug "<- #{uri.request_uri} redirects to",
                  "-> #{new_location.request_uri}"
          end

          fetch(new_location, redirect_limit-1)
        else
          ApiResponse.new(response)
        end
      end
    end

    def method_missing(method, *args, &block)
      if METHODS[method]
        self.public_send(METHODS[method][:http_type], method, *args)
      else
        super
      end
    end

    private
    def build_url(api_method, parameters)
      api_method.build(@base_url, parameters)
    end

    def get_method_url(method, parameters)
      api_method = METHODS[method][:method]

      return build_url(api_method, parameters)
    end

    def debug(*messages)
      puts messages.join("\n")
    end
  end
end

