class Movie < ActiveRecord::Base
  def getRating
     self.rating
  end
end
