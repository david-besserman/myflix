require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it 'returns the title of the associated video' do
      vid = Fabricate(:video, title: 'monk')
      queue_item = Fabricate(:queue_item, video: vid)
      expect(queue_item.video_title).to  eq('monk')
    end
  end

  describe "#rating" do
    it 'returns the rating of the review when the review is present' do
      vid = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: vid, rating: 3)
      queue_item = Fabricate(:queue_item, video: vid, user: user)
      expect(queue_item.rating).to eq(3)
    end

    it 'returns nil when the review is not present' do
      vid = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: vid, user: user)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the name of the associated video's category" do
      cat = Fabricate(:category, name: 'comedies')
      vid = Fabricate(:video, category: cat)
      queue_item = Fabricate(:queue_item, video: vid)
      expect(queue_item.category_name).to eq('comedies')
    end
  end

  describe "#category" do
    it "returns the name of the associated video's category" do
      cat = Fabricate(:category, name: 'comedies')
      vid = Fabricate(:video, category: cat)
      queue_item = Fabricate(:queue_item, video: vid)
      expect(queue_item.category).to eq(cat)
    end
  end
end
