require_relative '../Classes/Store'
require 'json'

module StoreModule
  def self.generateStore()
    # data_menu = File.open "/home/miqdadyyy/RubymineProjects/Go-Eat/Data/store_menu.json"
    data_menu = JSON.parse(File.open("Data/store_menu.json").read)
    data_name = JSON.parse(File.open("Data/store_name.json").read)
    menu_count = rand(9) + 2
    menus = Array.new(menu_count) { data_menu[rand(data_menu.size)] }
    store = Store.new(data_name[rand(10)], menus)
  end
end
