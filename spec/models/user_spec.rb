require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:reviews).order('created_at DESC') }

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_true
    end

    it "returns false when the user has not queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should_not be_true
    end
  end

  describe '#already_follows?' do
    context 'current user already follows another user' do
      it 'returns true' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: alice, leader: bob)
        expect(alice.already_follows?(bob)).to be_true
      end
    end

    context 'current user does not follow another user' do
      it 'returns false' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        expect(alice.already_follows?(bob)).to be_false
      end
    end
  end
end
