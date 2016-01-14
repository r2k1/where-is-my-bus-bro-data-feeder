require_relative 'at_api'
require 'mongo'
require 'dotenv'

Dotenv.load


mongo_client = Mongo::Client.new(ENV['MONGO_URL'])
vehicles = mongo_client[:vehicles]

data = ATApi.get_locations['response']['entity'].map do |e|
  {
    route_id: e['vehicle']['trip']['route_id'],
    lat: e['vehicle']['position']['latitude'],
    lon: e['vehicle']['position']['longitude'],
    _id: e['vehicle']['vehicle']['id']
  }
end

existed_data = vehicles.find.to_a

vehicles_to_create = data.select do |row|
  !existed_data.any? { |e| e[:_id] == row[:_id] }
end

vehicles_to_remove = existed_data.select do |row|
  !data.any? { |e| e[:_id] == row[:_id] }
end

vehicles_to_update = data.select do |row|
  existed_data.any? { |e| e[:_id] == row[:_id] }
end

p "Create: #{vehicles_to_create.map { |v| v[:_id]}}"
p "Remove: #{vehicles_to_remove.map { |v| v[:_id]}}"
p "Update: #{vehicles_to_update.map { |v| v[:_id]}}"


vehicles.insert_many vehicles_to_create
vehicles.delete_many(:_id => { '$in' => vehicles_to_remove.map { |v| v[:_id]}})
vehicles_to_update.each do |vehicle|
  vehicles.update_one({_id: vehicle[:_id]}, { "$set" => {lat: vehicle[:lat], lon: vehicle[:lon]}})
end


# TODO: Insert missing
# TODO: Update existed
# TODO: Delete not presented


# vehicles.insert_many data
