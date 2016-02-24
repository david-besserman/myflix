class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Welcome to myflix"
  end

  def send_password_reinitialization_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Please reset your password"
  end
end
