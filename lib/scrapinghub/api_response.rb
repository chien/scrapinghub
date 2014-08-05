require 'json'

module Scrapinghub
  class ApiResponse
    def initialize(net_http_request)
      case net_http_request
      when Net::HTTPOK
        @body = JSON.parse(net_http_request.body)
      else
        raise "Invalid Net:HTTP request sent to ApiResponse"
      end
    end

    def response
      @body
    end
  end
end
