require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    context 'authenticated user' do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it 'sets @video' do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      
      it 'sets @reviews' do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        assigns(:reviews).should =~ [review1, review2]
      end
    end

    context 'unauthenticated user' do
      it 'redirects to the sign in page' do
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end 
    end
  end

  describe '#POST search' do
    let(:futurama) { Fabricate(:video, title: 'futurama' )}

    context 'authenticated user' do
      it 'sets @results' do
        session[:user_id] = Fabricate(:user).id
        post :search, search_term: 'rama'
        expect(assigns(:results)).to eq([futurama])
      end
    end

    context 'unauthenticated user' do
      it 'redirects to the sign in page' do
        post :search, search_term: 'rama'
        expect(assigns(:results)).to redirect_to sign_in_path
      end
    end
  end
end
