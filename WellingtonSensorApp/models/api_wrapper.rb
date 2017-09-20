require 'rubygems'
require 'httparty'
require_relative 'data_mapper'

class APIWrapper
  include HTTParty
  base_uri "api.necsmart.city/v0.1/"
  @@token = nil

  def sensor
    self.class.get("/sensors/#{id}/events?token=#{@@token}")
  end

  def sensors
    @@token = Token.first(:scope => 'wellington').token
    self.class.get("/sensors?token=#{@@token}")
  end

  def token
    self.class.post('/wellington-token')
  end
end
