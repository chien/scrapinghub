module Scrapinghub
  class ApiMethod
    def initialize(location, requires={})
      @location = "#{location}.json"
      @requires = requires
    end

    def build(base_url, parameters = {})
      @parameters = parameters

      build_params!
      build_uri!(base_url)

      @uri
    end

    def build_params!
      @requires.each do |required_parameter|
        unless @parameters[required_parameter]
          raise ArgumentError.new "#{required_parameter} is required to access #{@location}"
        end
      end
    end

    def build_uri!(base_url)
      @uri = URI( File.join(base_url, @location) )
      @uri.query = URI.encode_www_form(@parameters)
    end
  end
end

