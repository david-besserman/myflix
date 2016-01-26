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

  describe 'DELETE destroy' do
    context 'for authenticated user' do
      it 'redirects to the my queue page' do
        session[:user_id] = Fabricate(:user)
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it 'deletes the queue item' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end
      
      it "normalizes the remaining queue items" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.position).to eq(1)

      end

      context "the queue item is not in the current user's queue" do
        it "does not delete the queue item" do
          alice = Fabricate(:user)
          bob = Fabricate(:user)
          session[:user_id] = alice.id
          queue_item = Fabricate(:queue_item, user: bob)
          delete :destroy, id: queue_item.id
          expect(QueueItem.count).to eq(1)
        end
      end
    end

    context 'for unautheticated user' do
      it 'redirects to the sign in page for the unauthenticated user' do
        delete :destroy, id: 3
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST update_queue" do
    context "With authenticated user" do
      context "with valid inputs" do
        let(:alice) { Fabricate(:user) }
        let(:video) { Fabricate(:video) }
        let(:queue_item1) { Fabricate(:queue_item, user: alice, video: video, position: 1) }
        let(:queue_item2) { Fabricate(:queue_item, user: alice, video: video, position: 2) }
        
        before do
          session[:user_id] = alice.id
        end

        it "redirects to the my queue page" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(response).to redirect_to my_queue_path
        end

        it "reorders the queue items" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(alice.queue_items).to eq([queue_item2, queue_item1])
        end

        it "it normalizes the position numbers" do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
          expect(alice.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context "with invalid inputs" do
        let(:alice) { Fabricate(:user) }
        let(:video) { Fabricate(:video) }
        let(:queue_item1) { Fabricate(:queue_item, user: alice, video: video, position: 1) }
        let(:queue_item2) { Fabricate(:queue_item, user: alice, video: video, position: 2) }
        
        before do
          session[:user_id] = alice.id
        end

        it 'redirects the flash error message' do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
          expect(response).to redirect_to my_queue_path
        end

        it 'sets the flash error message' do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
          expect(flash[:error]).to be_present
        end

        it 'does not change the queue item' do
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
          expect(queue_item1.reload.position).to eq(1)
        end
      end
    end

    context "with unauthenticated user" do
      it "redirects to the sign_in path" do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end
    
    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        video = Fabricate(:video)
        bob = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: bob, video: video, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, video: video, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
