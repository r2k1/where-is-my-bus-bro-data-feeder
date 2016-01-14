require_relative 'at_api'
require 'mongo'
require 'dotenv'
require 'pry'

class VehicleSynchronizer
  attr_accessor :data, :existed_data, :collection, :routes

  def initialize
    self.collection = Mongo::Client.new(ENV['MONGO_URL'])[:vehicles]
    self.routes = ATApi.new.get_routes['response']
  end

  def sync
    update_data
    collection.bulk_write(create_query + remove_query + update_query)
  end

  private

  def update_data
    self.data = ATApi.new.get_locations['response']['entity'].map do |e|
      {
        route_id: e['vehicle']['trip']['route_id'],
        lat: e['vehicle']['position']['latitude'],
        lon: e['vehicle']['position']['longitude'],
        _id: e['vehicle']['vehicle']['id']
      }
    end
    self.existed_data = collection.find.to_a
  end

  def create_query
    vehicles = vehicles_to_create
    p "Create #{vehicles.count}"
    vehicles.map { |v| { insert_one: v } }
  end

  def update_query
    vehicles = vehicles_to_update
    p "Update #{vehicles.count}"
    vehicles.map do |v|
      {
        update_one: {
          filter: { _id: v[:_id] },
          update: { '$set' => { lat: v[:lat], lon: v[:lon] } }
        }
      }
    end
  end

  def remove_query
    vehicles = vehicles_to_remove
    p "Remove #{vehicles.count}"
    vehicles.map do |v|
      {
        delete_one: {
          filter: { _id: v[:_id] }
        }
      }
    end
  end

  def vehicles_to_create
    vehicles = data.select do |row|
      !existed_data.any? { |e| e[:_id] == row[:_id] }
    end
    vehicles.each do |vehicle|
      route = routes.find { |r| r['route_id'] = vehicle[:route_id] }
      vehicle[:route_short_name] = route['route_short_name']
      vehicle[:route_long_name] = route['route_long_name']
    end
    vehicles
  end

  def vehicles_to_remove
    existed_data.select do |row|
      !data.any? { |e| e[:_id] == row[:_id] }
    end
  end

  def vehicles_to_update
    data.select do |row|
      existed_data.any? { |e| e[:_id] == row[:_id] }
    end
  end
end

Dotenv.load
VehicleSynchronizer.new.sync
