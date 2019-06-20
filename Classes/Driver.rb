class Driver
  attr_reader :name, :pos, :rating, :ratings

  def initialize(name, pos, rating)
    @name = name
    @pos = pos
    @rating = rating
    @ratings = []
  end

  def addRating(rate)
    @@ratings << rate
    total = 0
    @@ratings.each do |x|
      total += x
    end
    @rating = total / @@rating.size
  end
end
