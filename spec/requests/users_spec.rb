# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /show' do
    xit 'returns http success' do
      sign_in user
      # ADD mock call Spotfiy.get_userdata
      get '/users/show'
      expect(response).to have_http_status(:success)
    end
  end
end
