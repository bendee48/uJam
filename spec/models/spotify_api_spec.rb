# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpotifyApi, type: :model do
  subject(:spotify_api) { described_class }
  let(:user) { create(:user) }

  describe '.authorize', :api_request_helper do
    it 'returns a successful response object' do
      state_code = '5tat3c0d3'
      stubbed_authorise(state_code) # API request helper method

      response = spotify_api.authorize(state_code)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end

  describe '.state_code' do
    it 'returns a random string each time' do
      code1 = spotify_api.state_code
      code2 = spotify_api.state_code
      expect(code1).to_not eql code2
    end
  end

  describe '.request_token', :api_request_helper do
    it 'returns a response object' do
      auth_code = 'au0th'
      stubbed_request_token(auth_code)

      response = spotify_api.request_token(auth_code)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end

  describe '.get_refresh_refreshed_token' do
    it 'returns a response object' do
      stub_request(:post, spotify_api::TOKEN_URL)
        .with(body: { grant_type: 'refresh_token',
                      refresh_token: user.refresh_token },
              headers: { authorization: "Basic #{spotify_api.encoded_credentials}" })

      response = spotify_api.request_refreshed_token(user)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end

  describe '.get_userdata' do
    it 'returns a response object' do
      api_url = 'https://api.spotify.com/v1/me'

      stub_request(:get, api_url)
        .with(headers: { authorization: "Bearer #{user.access_token}" })

      response = spotify_api.get_userdata(api_url, user)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end
end
