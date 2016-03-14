require 'dotenv'
require_relative 'vehicle_synchronizer'

Dotenv.load
syncronizer = VehicleSynchronizer.new
while true
  syncronizer.sync
  sleep 20
end
