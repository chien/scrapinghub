module Scrapinghub
  class ApiMethod
    def initialize(location, requires={})
      @location = "#{location}.json"
      @requires = requires
    end

    def build(base_url, parameters = {})
      @requires ||= []

      parameters = {}

      build_params!
      build_uri!(base_url)

      [@uri, @parameters]
    end

    def build_params!
      @parameters = {}

      @requires.each do |required_parameter|
        unless @requires[required_parameter]
          raise ArgumentError.new "#{required_parameter} is required to access #{@location}"
        end

        @parameters[required_parameter] = @requires[required_parameter]
      end
    end

    def build_uri!(base_url)
      @uri = URI( File.join(base_url, @location) )
    end
  end
end

