module ApplicationHelper
  MAX_RATING = 5
  MIN_RATING = 1

  def options_for_selecting_rating(selected=nil)
    options_for_select(available_ratings_array, selected)
  end

  def available_ratings_array
    countdown_within_array.map{|number| [pluralize(number, "star"), number]}
  end
  
  def countdown_within_array
    MAX_RATING.downto(MIN_RATING).to_a
  end
end
