module MapModule

  def self.generateMapPath(map_, pos, dest)
    map = Marshal.load(Marshal.dump(map_))
    px = pos[:x]
    py = pos[:y]
    dx = dest[:x]
    dy = dest[:y]
    cost = 0

    while(px != dx)
      px += px < dx ? 1 : -1
      map[py][px] = '*'
      cost += 1
    end

    while(py != dy)
      py += py < dy ? 1 : -1
      if(py != dy)
        map[py][px] = '*'
      end
      cost += 1
    end

    {:map => map, :cost => cost}
  end
end
