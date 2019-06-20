require_relative '../Classes/Driver'
require 'json'

module DriverModule
  def self.generateDriver(x, y)
    # data_menu = File.open "/home/miqdadyyy/RubymineProjects/Go-Eat/Data/driver_menu.json"
    data_name = JSON.parse(File.open("Data/driver_name.json").read, :symbolize_names => true)
    store = Driver.new(data_name[rand(8)], {:x => x, :y => y}, 0)
  end
end
