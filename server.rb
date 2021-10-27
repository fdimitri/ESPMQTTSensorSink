require 'rubygems'
require 'solargraph'
require 'em/mqtt'
require 'awesome_print'
require 'yaml'
require 'active_record'

require './db.rb'

EventMachine::error_handler { |e| puts "#{e}: #{e.backtrace.first}" }


def messageCallback(msg)
    #MQTT::Packet::Publish
    #bool flags[4]
    #topic
    #body_length
    #payload
    puts YAML.dump(msg)
    topicRegex = Regexp.new("location/(?<device_location>[^/]+)/device/(?<device_name>[^/ ]+)")
    payloadRegex = Regexp.new("UPDATE.SENSOR (?<sensor_name>[^\s]+) (?<sensor_value>[^\s]+)")
    payload =  payloadRegex.match(msg.payload)
    topic =  topicRegex.match(msg.topic)
    puts YAML.dump(msg.topic)
    puts YAML.dump(msg.payload)
    deviceData = {
      :sensor_name => payload.sensor_name,
      :sensor_hardware => "changeme",
      :sensor_value => payload.sensor_value,
      :device_location => topic.device_location,
      :device_name => topic.device_name
    }
    d = DeviceDatum.new(deviceData)
    #d.save!
    ap deviceData
    ap d
end

EventMachine.run do
    EventMachine::MQTT::ClientConnection.connect(
    :host => '192.168.0.133',
    :username => 'emqx',
    :password => 'public'
  ) do |c|
    c.subscribe('#')
    c.receive_callback do |message|
      h = { :topic => message.topic, :msg => message.payload }
      ap h
      p message
      messageCallback(message)
    end
  end
end

