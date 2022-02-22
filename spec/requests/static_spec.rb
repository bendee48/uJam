# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Static', type: :request do
  let(:user) { User.create!(email: 'ruth@email.com', password: 'password') }

  describe 'GET /' do
    it 'works! (now write some real specs' do
      sign_in user
      get root_path
      expect(response).to render_template(:homepage)
      expect(response).to have_http_status(200)
    end
  end
end
