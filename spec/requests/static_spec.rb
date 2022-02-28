# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Static', type: :request do
  let(:user) { create(:user) }

  describe 'GET /' do
    it 'successfully loads homepage' do
      sign_in user
      get root_path
      expect(response).to render_template(:homepage)
      expect(response).to have_http_status(200)
    end
  end
end
