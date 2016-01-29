require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end

    context 'authenticated user' do
      before { set_current_user }

      it 'sets @video' do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      
      it 'sets @reviews' do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to include(review1, review2)
      end
    end
  end

  describe '#POST search' do
    let(:futurama) { Fabricate(:video, title: 'futurama' )}

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: 'rama' }
    end

    context 'authenticated user' do
      it 'sets @results' do
        set_current_user
        post :search, search_term: 'rama'
        expect(assigns(:results)).to eq([futurama])
      end
    end
  end
end
