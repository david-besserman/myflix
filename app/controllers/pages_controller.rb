class PagesController < ApplicationController
  def front
    redirect_to home_path if current_user
  end

  def haml_test
  end
end
