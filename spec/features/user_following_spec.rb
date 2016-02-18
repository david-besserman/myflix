require 'spec_helper'

feature 'User following' do
  scenario 'user follows and unfollows someone' do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    review = Fabricate(:review, user: alice, video: video)

    sign_in_and_follow_the_user_that_reviewed_video(video)
    expect(page).to have_content(alice.full_name)

    unfollow
    expect(page).not_to have_content(alice.full_name)
  end

  private

  def sign_in_and_follow_the_user_that_reviewed_video(video)
    sign_in
    click_on_video_link(video)
    go_to_user_page_and_follow(video.reviews.first.user)
  end

  def go_to_user_page_and_follow(user)
    click_link user.full_name
    click_link "Follow"
  end

def unfollow
    find("a[data-method='delete']").click
  end
end
