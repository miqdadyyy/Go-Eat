class Map
  attr_accessor :map, :stores
  attr_reader :width, :height

  def initialize(*args)
    @stores = []

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
      @width = 20
      @height = 20
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
        @stores << {:x => x, :y => y, :store => StoreModule.generateStore}
      end
      @map[y][x] = character
    end
    @map
  end

  def generateMap(objects, character)
    for object in objects
      if(character == 'S')
        @stores << object
      end
      @map[object[:y].to_i][object[:x].to_i] = character
    end
  end
end
