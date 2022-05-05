# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user, :unauthorised) }

  describe 'GET /show' do
    it 'returns http success' do
      sign_in user
      get user_path(user)
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end
  end
end
