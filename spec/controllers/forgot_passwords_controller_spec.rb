require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with blank input' do
      before { post :create, email: '' }

      it 'redirect to the forgot password page' do
        expect(response).to redirect_to forgot_password_path 
      end

      it 'displays an error message' do
        expect(flash[:error]).to eq("Email cannot be blank.")
      end
    end

    context 'with existing email' do
      before do
        ActionMailer::Base.deliveries.clear
        Fabricate(:user, email: 'toto@example.com')
        post :create, email: 'toto@example.com'
      end

      it 'redirects to the forgot password confirmation page' do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it 'sends out an email to the email address' do
        sent_email_destination = ActionMailer::Base.deliveries.last.to
        expect(sent_email_destination).to eq(['toto@example.com'])
      end
    end

    context 'with non-existing email' do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, email: 'toto@example.com'
      end

      it "redirects to the forgot password page" do
        expect(response).to redirect_to(forgot_password_path)
      end

      it "shows an error message" do
        expect(flash[:error]).to eq("There is no user with that email in teh system")
      end
    end
  end
end
