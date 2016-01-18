require 'net/http'
require 'uri'
require 'json'

class ATApi
    BASE_URL = 'https://api.at.govt.nz/v1'
    def get_locations
      get_json('public/realtime/vehiclelocations')
    end

    def get_routes
      get_json('gtfs/routes')
    end

    def get_json(path)
      begin
        uri = URI("#{BASE_URL}/#{path}?api_key=#{ENV['AT_API_KEY']}")
        json = Net::HTTP.get(uri)
        JSON.parse(json)
      rescue Errno::ECONNRESET
        nil
      end
    end
end
