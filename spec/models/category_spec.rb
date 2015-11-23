require 'spec_helper'

describe Category do
  it "returns the videos in the reverse chronological order by created_at" do
    cat = Category.create(name: "some category")
    some_vid = Video.create(title: "some title", description: "some description", created_at: 1.day.ago, category: cat)
    latest_vid = Video.create(title: "latest video", description: "some description", category: cat)
    expect(cat.recent_videos).to eq([latest_vid, some_vid])
  end

  it "returns all videos if there are 6 or less" do
    cat = Category.create(name: "some category")
    some_vid = Video.create(title: "some title", description: "some description", created_at: 1.day.ago, category: cat)
    latest_vid = Video.create(title: "latest video", description: "some description", category: cat)
    expect(cat.recent_videos.count).to eq(2)
  end

  it "returns the most recent 6 videos if there are more that 6" do
    cat = Category.create(name: "some category")
    7.times {Video.create(title: "some title", description: "some description", category: cat)}
    expect(cat.recent_videos.count).to eq(6)
  end
  
  it "returns the most recent 6 videos" do
    cat = Category.create(name: "some category")
    some_vid = Video.create(title: "some title", description: "some description", created_at: 1.day.ago, category: cat)
    6.times {Video.create(title: "some title", description: "some description", category: cat)}
    expect(cat.recent_videos).not_to include(some_vid)
  end

  it "returns an empty array if the category does not have any videos" do
    cat = Category.create(name: "some category")
    expect(cat.recent_videos).to eq([])
  end
end
