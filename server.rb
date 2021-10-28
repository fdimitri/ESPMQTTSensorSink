require 'rubygems'
require 'solargraph'
require 'em/mqtt'
require 'awesome_print'
require 'yaml'
require 'active_record'

require './db.rb'

EventMachine::error_handler { |e| puts "#{e}: #{e.backtrace.first}" }


def messageCallback(msg, topic)
    #MQTT::Packet::Publish
    #bool flags[4]
    #topic
    #body_length
    #payload
    topicRegex = Regexp.new("location/(?<device_location>[^/]+)/device/(?<device_name>[^/ ]+)")
    payloadRegex = Regexp.new("UPDATE.SENSOR (?<sensor_name>[^\s]+) (?<sensor_value>[^\s]+)")
    payload =  payloadRegex.match(msg)
    topic =  topicRegex.match(topic)
    if (!topic || !payload) then
      return false
    end
    ap msg
    ap topic
    deviceData = {
      :sensor_name => payload[:sensor_name],
      :sensor_hardware => "changeme",
      :sensor_value => payload[:sensor_value],
      :device_location => topic[:device_location],
      :device_name => topic[:device_name]
    }
    d = DeviceDatum.new(deviceData)
    d.save!
    ap deviceData
    ap d
end

topicRegex = Regexp.new("location/(?<device_location>[^/]+)/device/(?<device_name>[^/ ]+)")
payloadRegex = Regexp.new("UPDATE.SENSOR (?<sensor_name>[^\s]+) (?<sensor_value>[^\s]+)")
MQTT::Client.connect(:host => '192.168.0.133', :username => 'emqx',:password => 'public') do |c|
  c.get('#') do |topic, message|
    messageCallback(message, topic)
  end
end
