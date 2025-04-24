require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user, email_address: 'user@example.com', password: 'password123', password_confirmation: 'password123') }

  describe 'POST /session' do
    context 'with valid credentials' do
      it 'creates a new session and redirects' do
        expect {
          post '/session', params: {
            email_address: user.email_address,
            password: 'password123'
          }
        }.to change { user.sessions.count }.by(1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(after_authentication_url)
      end
    end

    context 'with invalid credentials' do
      it 'redirects with alert' do
        post '/session', params: {
          email_address: user.email_address,
          password: 'wrong_password'
        }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq('Try another email address or password.')
      end
    end
  end

  describe 'DELETE /session' do
    before do
      post '/session', params: { email_address: user.email_address, password: 'password123' }
      @session_id = user.sessions.last.id
    end

    it 'terminates the session and redirects' do
      expect {
        delete '/session'
      }.to change { user.sessions.count }.by(-1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_session_path)
    end
  end

  private

  def after_authentication_url
    root_url
  end
end
