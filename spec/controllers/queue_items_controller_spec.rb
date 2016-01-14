require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "sets the @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign-in page for unaunthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'POST create' do
    context 'with authenticated user' do
      it 'redirects to the my_queue page' do
        session[:user_id] = Fabricate(:user).id
        vid = Fabricate(:video)
        post :create, video_id: vid.id
        expect(response).to redirect_to my_queue_path
      end
      
      it 'creates a queue item' do
        session[:user_id] = Fabricate(:user).id
        vid = Fabricate(:video)
        post :create, video_id: vid.id
        expect(QueueItem.count).to eq(1) 
      end

      it 'creates a queue item that is associated with the video' do
        session[:user_id] = Fabricate(:user).id
        vid = Fabricate(:video)
        post :create, video_id: vid.id
        expect(QueueItem.first.video).to eq(vid) 
      end

      it 'creates a queue item that is associated with the signed in user' do
        alice = Fabricate(:user)
        session[:user_id]  = alice.id
        vid = Fabricate(:video)
        post :create, video_id: vid.id
        expect(QueueItem.first.user).to eq(alice) 
      end

      it 'puts the video as the last one in the queue' do
        alice = Fabricate(:user)
        session[:user_id]  = alice.id
        monk = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: alice)
        south_park = Fabricate(:video)
        post :create, video_id: south_park.id
        south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: alice.id).first
        expect(south_park_queue_item.position).to eq(2)
      end
      
      context 'with the video already in the queue' do
        it 'does not add the video to the queue' do
          alice = Fabricate(:user)
          session[:user_id]  = alice.id
          monk = Fabricate(:video)
          Fabricate(:queue_item, video: monk, user: alice)
          post :create, video_id: monk.id
          expect(alice.queue_items.count).to eq(1)
        end
      end
    end

    context 'with unauthenticated user' do
      it 'redirects to the sign in page' do
        post :create, video_id: 3
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
