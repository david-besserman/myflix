require 'spec_helper'

describe Category do
  it "returns the videos in the reverse chronological order by created_at" do
    cat = Fabricate(:category)
    some_vid = Fabricate(:video, created_at: 1.day.ago, category: cat)
    latest_vid = Fabricate(:video, category: cat)
    expect(cat.recent_videos).to eq([latest_vid, some_vid])
  end

  it "returns all videos if there are 6 or less" do
    cat = Fabricate(:category)
    some_vid = Fabricate(:video, created_at: 1.day.ago, category: cat)
    latest_vid = Fabricate(:video, category: cat)
    expect(cat.recent_videos.count).to eq(2)
  end

  it "returns the most recent 6 videos if there are more that 6" do
    cat = Fabricate(:category)
    7.times {Fabricate(:video, category: cat)}
    expect(cat.recent_videos.count).to eq(6)
  end
  
  it "returns the most recent 6 videos" do
    cat = Fabricate(:category)
    some_vid = Fabricate(:video, created_at: 1.day.ago, category: cat)
    6.times {Fabricate(:video, category: cat)}
    expect(cat.recent_videos).not_to include(some_vid)
  end

  it "returns an empty array if the category does not have any videos" do
    cat = Fabricate(:category)
    expect(cat.recent_videos).to eq([])
  end
end
