require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    comedies   = Fabricate(:category)
    south_park = Fabricate(:video, title: 'south park', category: comedies)
    monk       = Fabricate(:video, title: 'monk', category: comedies)
    futurama   = Fabricate(:video, title: 'futurama', category: comedies)

    sign_in
    
    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)
    
    set_video_position(south_park, 1)
    set_video_position(futurama, 2)
    set_video_position(monk, 3)

    update_queue

    expect_video_position(south_park, 1)
    expect_video_position(futurama, 2)
    expect_video_position(monk, 3)
  end

  private

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content link_text
  end
  def add_video_to_queue(video)
    visit home_path
    click_on_video_link(video)
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end