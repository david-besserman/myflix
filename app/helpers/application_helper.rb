module ApplicationHelper
  def generate_options_for_selecting_stars(n)
    countdown_within_array(n).map{|number| [pluralize(number, "star"), number]}
  end
  
  # this helper will transform an int into an array containing each int from n to 1 
  # example: countdown_within_array(5) => [5, 4, 3, 2, 1]
  def countdown_within_array(n)
    i = n 
    array = []

    while i >  0
      array.push(i)
      i -= 1
    end

    array
  end
end
