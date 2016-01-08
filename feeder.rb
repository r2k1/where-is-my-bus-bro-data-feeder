require_relative 'auckland_transport_api'
require 'mongo'
require 'pry'
require 'dotenv'

Dotenv.load
Mongo::Client.new(ENV['MONGO_URL'])
Pry::ColorPrinter.pp(AucklandTranportApi.get_data(106))
