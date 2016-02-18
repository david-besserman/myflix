require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it "it sets @relationships to the current user's following relationships" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, id: 4 }
    end

    context 'current_user is the follower' do
      it 'deletes the relationship' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(alice)
        relationship = Fabricate(:relationship, leader: bob, follower: alice)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end
    end

    context 'current_user is not the follower' do
      it 'does not delete the relationship' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(bob)
        relationship = Fabricate(:relationship, leader: bob, follower: alice)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
      end
    end
    
    it 'redirects to the people page' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to(people_path)
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create, leader_id: 3 }
    end

    it 'creates a relationship where the current user follows the leader' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it 'redirects to the people page' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: bob.id
      expect(response).to redirect_to(people_path)
    end

    it 'does not create a relationship if the current user already follows the leader' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it 'does not allow one to follow themselves' do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end
end
