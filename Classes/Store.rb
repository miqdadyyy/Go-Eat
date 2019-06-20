class Store
  attr_reader :name, :menus, :pos
  def initialize(name, menus, pos)
    @name = name
    @menus = menus
    @pos = pos
  end

end
