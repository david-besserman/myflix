require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end 
  end
  
  describe 'POST create' do
    context 'with valid input' do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'creates the user' do
        expect(User.count).to eq(1)
      end
      
      it 'redirects to the sign_in page' do
        expect(response).to redirect_to sign_in_path 
      end

      describe 'email sending' do
        after { ActionMailer::Base.deliveries.clear }

        it 'sends an email' do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'is sent to the right adress' do
          user = User.first
          sent_email = ActionMailer::Base.deliveries.last
          expect(sent_email.to).to eq([user.email])
        end

        it 'is sent with the right content' do
          user = User.first
          sent_email = ActionMailer::Base.deliveries.last
          expected_message = "Welcome to Myflix #{user.full_name} !"
          expect(sent_email.body).to  include(expected_message)
        end
        # there is another test relative to email sending in the 'with invalid input' context called "doesn't send a welcome email"
      end
    end

    context 'with invalid input' do
      before do
        post :create, user: {password: 'password', full_name: 'David B'}
      end

      it 'does not create the user' do
        expect(User.count).to eq(0)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new 
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
      
      it "doesn't send a welcome email" do
        user = User.first
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
  describe 'GET show' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: 3 }
    end
    it 'sets @user' do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end
