class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list)
    if ratings_list == nil
      Movie.all
    else
      Movie.where(rating: ratings_list)
    end
  end
end
