class Map
  attr_accessor :map, :stores
  attr_reader :width, :height

  def initialize(args = nil)
    @width = 20
    @height = 20
    @map = Array.new(20){ Array.new(20){ "." } }
    @stores = []

    case args
    when nil
      drivers_count = 5
      stores_count = 3
      generateMapRandom(drivers_count, 'D')
      generateMapRandom(stores_count, 'S')
      generateMapRandom(1, 'U')
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

      if(character == 'S')
        @stores << {:x => x, :y => y, :store => StoreModule.generateStore}
      end
      @map[y][x] = character
    end

  end
end
