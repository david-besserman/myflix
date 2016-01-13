module ApplicationHelper
  def generate_options_for_selecting_stars(n)
    countdown_within_array(n).map{|number| [pluralize(number, "star"), number]}
  end
  
  def countdown_within_array(n)
    n.downto(1).to_a
  end
  # countdown_within_array(5) => [5, 4, 3, 2, 1]
end
