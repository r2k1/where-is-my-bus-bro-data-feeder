require_relative 'at_api'
require 'mongo'
require 'dotenv'

class VehicleSynchronizer
  attr_accessor :data, :existed_data, :collection

  def initialize
    self.collection = Mongo::Client.new(ENV['MONGO_URL'])[:vehicle]
  end

  def sync
    update_data
    collection.bulk_write(create_query + remove_query + update_query)
  end

  private

  def update_data
    self.data = ATApi.get_locations['response']['entity'].map do |e|
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
    vehicles_to_create.map { |v| { insert_one: v } }
  end

  def update_query
    vehicles_to_update.map do |v|
      {
        update_one: {
          filter: { _id: v[:_id] },
          update: { '$set' => { lat: v[:lat], lon: v[:lon] } }
        }
      }
    end
  end

  def remove_query
    vehicles_to_remove.map do |v|
      {
        delete_one: {
          filter: { _id: v[:_id] }
        }
      }
    end
  end

  def vehicles_to_create
    data.select do |row|
      !existed_data.any? { |e| e[:_id] == row[:_id] }
    end
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
