class ForgotPasswordsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user
      AppMailer.send_password_reinitialization_email(user).deliver
      redirect_to forgot_password_confirmation_path 
    else
      flash[:error] = set_error_message(params[:email])
      redirect_to forgot_password_path
    end
  end

  private
  
  def set_error_message(email_address)
    email_address.blank? ? "Email cannot be blank." : "There is no user with that email in teh system"
  end
end
