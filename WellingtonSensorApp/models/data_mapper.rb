require 'sinatra'
require 'json'
require 'data_mapper'
require_relative "api_wrapper"

set :bind, '127.0.0.1'
set :port, 5000

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/models/wellington-sensors.db")

class Token
  include DataMapper::Resource

  property :token, Text, :key => true
  property :scope, Text, required: true
  property :expires_at, Text, required: true # TODO Make this a datetime.
end

class Sensor
  include DataMapper::Resource

  property :id, Text, :key => true
  property :name, Text, required: true
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

class DatabaseInsert
  @@apiWrapper = APIWrapper.new

  def createToken
    tokenJSON = @@apiWrapper.token
    new_token = Token.new
    new_token.token = "#{tokenJSON["token"]}"
    new_token.scope = "#{tokenJSON["scope"]}"
    new_token.expires_at = "#{tokenJSON["expires_at"]}"
    new_token.save
  end

  def createSensors
    sensorsJSON = @@apiWrapper.sensors
    sensorsArray = sensorsJSON["sensors"]
    sensorsArray.each do |sensorJSON|
      new_sensor = Sensor.new
      new_sensor.id = "#{sensorJSON["id"]}"
      new_sensor.name = "#{sensorJSON["sensor_name"]}"
      new_sensor.save
    end
  end

end

databaseInserter = DatabaseInsert.new
databaseInserter.createToken
databaseInserter.createSensors
