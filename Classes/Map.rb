# frozen_string_literal: true

require_relative 'Driver'
require_relative 'Store'
require_relative '../Modules/DriverModule'
require_relative '../Modules/StoreModule'

class Map
  attr_accessor :map, :stores, :drivers, :user
  attr_reader :width, :height

  def initialize(*args)
    @stores = []
    @drivers = []

    case args.size
    when 0
      @width = 20
      @height = 20
      @map = Array.new(@height) { Array.new(@width) { '.' } }

      drivers_count = 5
      stores_count = 3
      generate_map_random(drivers_count, 'D')
      generate_map_random(stores_count, 'S')
      puts "call random"
      generate_map_random(1, 'U')

    when 3
      @width = args[0].to_i
      @height = args[0].to_i
      @map = Array.new(@height) { Array.new(@width) { '.' } }

      drivers_count = 5
      stores_count = 3
      generate_map_random(drivers_count, 'D')
      generate_map_random(stores_count, 'S')

      pos_user_x = args[1].to_i
      pos_user_y = args[2].to_i
      @map[pos_user_y][pos_user_x] = 'U'
      @user = { x: pos_user_x, y: pos_user_y }
    when 1
      map_data = JSON.parse(File.open('Data/' + args[0]).read, symbolize_names: true)
      @width = map_data[:width]
      @height = map_data[:height]
      @map = Array.new(@height) { Array.new(@width) { '.' } }

      drivers_count = map_data[:drivers].size
      stores_count = map_data[:stores].size
      generate_map(map_data[:drivers], 'D')
      generate_map(map_data[:stores], 'S')
      generate_map([map_data[:user]], 'U')
    end
  end

  def show_map(map = @map)
    map.map.each do |i|
      i.each do |j|
        print j
      end
      puts
    end
    nil
  end



  def generate_map_random(count, character)
    (1..count).each do |_i|
      x = rand(@width)
      y = rand(@height)
      while @map[y][x] != '.'
        x = rand(@width)
        y = rand(@height)
      end

      if character == 'S'
        @stores << StoreModule.generateStore(x, y)
      elsif character == 'D'
        @drivers << DriverModule.generateDriver(x, y)
      elsif character == 'U'
        @user = {x: x, y: y}
      end
      @map[y][x] = character
    end
    @map
  end

  def generate_map(objects, character)
    objects.each do |object|
      if character == 'S'
        @stores << Store.new(object[:name], object[:menus], object[:pos])
      elsif character == 'D'
        @drivers << Driver.new(object[:name], object[:pos], object[:rating])
      elsif character == 'U'
        @user = object[:pos]
      end
      @map[object[:pos][:y].to_i][object[:pos][:x].to_i] = character
    end
  end
end
