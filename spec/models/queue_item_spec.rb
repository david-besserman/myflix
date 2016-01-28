require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

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

  describe '#rating=' do
    context 'the review is present' do
      it 'changes the rating of the review' do
        video = Fabricate(:video)
        user = Fabricate(:user)
        review = Fabricate(:review, user: user, video: video, rating: 2)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating = 4
        expect(Review.first.rating).to eq(4)
      end

      it 'clears the rating of the review' do
        video = Fabricate(:video)
        user = Fabricate(:user)
        review = Fabricate(:review, user: user, video: video, rating: 2)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating = nil
        expect(Review.first.rating).to be_nil
      end
    end

    context 'the review is not present' do
      it 'creates a review with the rating' do
        video = Fabricate(:video)
        user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating = 3
        expect(Review.first.rating).to eq(3)
      end
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
