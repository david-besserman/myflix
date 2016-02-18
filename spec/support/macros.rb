def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)) .id
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit(sign_in_path)
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign-in'
end

def click_on_video_link(video)
  find("a[href='/videos/#{video.id}']").click 
end
