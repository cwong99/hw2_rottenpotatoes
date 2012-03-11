class Movie < ActiveRecord::Base
  @@all_ratings = ["G","PG","PG-13","R"]
  def Movie.all_ratings
     @@all_ratings
  end

end
