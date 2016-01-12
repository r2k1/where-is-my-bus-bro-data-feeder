require 'cgi'
require 'base64'
require 'openssl'
require 'net/http'
require 'uri'
require 'json'

# Auckland transport signature generatation algoritm
class AucklandTranportApi
  API_KEY = 'c2799f9d4f593eb7d77f2ccf6a509521'
  API_SECRET = 'da999252e5b90e7dee0e69a735ec23df'
  BASE_URL = 'https://api.at.govt.nz/v1/public-restricted/departures/'

  def self.get_data(bus_station)
    uri = URI(generate_url(bus_station))
    json = Net::HTTP.get(uri)
    JSON.parse(json)
  end

  private

  def self.generate_api_signature
    shit = Time.new.to_i.to_s + API_KEY
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), API_SECRET, shit)
  end

  def self.generate_url(bus_station)
    "#{BASE_URL}#{bus_station}?api_key=#{API_KEY}&api_sig=#{generate_api_signature}"
  end
end
