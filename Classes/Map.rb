require_relative 'Driver'
require_relative 'Store'
require_relative '../Modules/DriverModule'
require_relative '../Modules/StoreModule'

class Map
  attr_accessor :map, :stores, :drivers
  attr_reader :width, :height

  def initialize(*args)
    @stores = []
    @drivers = []

    case args.size
    when 0
      @width = 20
      @height = 20
      @map = Array.new(@height) {Array.new(@width) {"."}}

      drivers_count = 5
      stores_count = 3
      generateMapRandom(drivers_count, 'D')
      generateMapRandom(stores_count, 'S')
      generateMapRandom(1, 'U')

    when 3
      @width = args[0].to_i
      @height = args[0].to_i
      @map = Array.new(@height) {Array.new(@width) {"."}}

      drivers_count = 5
      stores_count = 3
      generateMapRandom(drivers_count, 'D')
      generateMapRandom(stores_count, 'S')

      pos_user_x = args[1].to_i
      pos_user_y = args[2].to_i
      @map[pos_user_y][pos_user_x] = 'U'
    when 1
      map_data = JSON.parse(File.open("Data/" + args[0]).read, :symbolize_names => true)
      @width = map_data[:width]
      @height = map_data[:height]
      @map = Array.new(@height) {Array.new(@width) {"."}}

      drivers_count = map_data[:drivers].size
      stores_count = map_data[:stores].size
      generateMap(map_data[:drivers], 'D')
      generateMap(map_data[:stores], 'S')
      generateMap([map_data[:user]], 'U')
    end
  end

  def showMap()
    for i in map.map
      for j in i
        print j
      end
      puts()
    end
    nil
  end

  private

  def generateMapRandom(count, character)
    for i in 1..count
      x, y = rand(@width), rand(@height)
      while @map[y][x] != '.'
        x, y = rand(@width), rand(@height)
      end

      if (character == 'S')
        @stores << StoreModule.generateStore(x, y)
      elsif
        @drivers << DriverModule.generateDriver(x,y)
      end
      @map[y][x] = character
    end
    @map
  end

  def generateMap(objects, character)
    for object in objects
      if(character == 'S')
        @stores << Store.new(object[:name], object[:menus], object[:pos])
      elsif(character == 'D')
        @drivers << Driver.new(object[:name], object[:pos], object[:rating])
      end
      @map[object[:pos][:y].to_i][object[:pos][:x].to_i] = character
    end
  end
end
