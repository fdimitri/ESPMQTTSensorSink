require 'awesome_print'
require 'yaml'
require 'active_record'
require './db.rb'


class CreateDeviceData < ActiveRecord::Migration[6.1]
    def change
      create_table :device_data do |t|
        t.string :device_name
        t.string :device_location
        t.string :sensor_hardware
        t.string :sensor_name
        t.float :sensor_value
        t.timestamps
      end
    end
  end
  