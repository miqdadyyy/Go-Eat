class Driver
  attr_reader :name, :pos, :rating, :ratings

  def initialize(name, pos, rating)
    @name = name
    @pos = pos
    @rating = rating
    @ratings = []
  end

  def add_rating(rate)
    @ratings << rate
    total = 0
    @ratings.each do |x|
      total += x
    end
    @rating = total / @ratings.size
  end
end
