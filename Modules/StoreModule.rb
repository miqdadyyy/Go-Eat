require_relative '../Classes/Store'
require 'json'

module StoreModule
  def self.generateStore(x, y)
    # data_menu = File.open "/home/miqdadyyy/RubymineProjects/Go-Eat/Data/store_menu.json"
    data_menu = JSON.parse(File.open("Data/store_menu.json").read, :symbolize_names => true)
    data_name = JSON.parse(File.open("Data/store_name.json").read, :symbolize_names => true)
    menu_count = rand(9) + 2
    menus = Array.new(menu_count) { data_menu[rand(data_menu.size)] }
    store = Store.new(data_name[rand(10)], menus, {:x => x, :y => y})
  end
end
