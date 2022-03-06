require 'rails_helper'

RSpec.describe SpotifyApi, type: :model do
  subject(:spotify_api) { described_class }
  let(:user) { create(:user) }

  describe '.authorize' do
    it 'returns a successful response object' do
      stub_request(:get, spotify_api::AUTHORIZE_URL)
        .with(query: { client_id: spotify_api::CLIENT_ID,
                       response_type: 'code',
                       scope: 'user-read-recently-played',
                       redirect_uri: spotify_api::REDIRECT_URL,
                       state: 'state code' })
        .to_return({})

      response = spotify_api.authorize('state code')
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end

  describe '.state_code' do
    it 'returns a random string each time' do
      code_1 = spotify_api.state_code
      code_2 = spotify_api.state_code
      expect(code_1).to_not eql code_2
    end
  end

  describe '.request_token' do
    it 'returns a response object' do
      allow(spotify_api).to receive(:encoded_credentials).and_return("credentials")

      stub_request(:post, spotify_api::TOKEN_URL)
        .with(body: { grant_type: 'authorization_code',
                      code: '12345',
                      redirect_uri: spotify_api::REDIRECT_URL,
                    },
              headers: { authorization: "Basic #{spotify_api.encoded_credentials}" })
        .to_return({})

        response = spotify_api.request_token('12345')
        expect(response).to be_a(Faraday::Response)
        expect(response.status).to eql 200
    end    
  end

  describe '.get_refresh_refreshed_token' do
    it 'returns a response object' do
      stub_request(:post, spotify_api::TOKEN_URL)
        .with(body: { grant_type: 'refresh_token', 
                      refresh_token: user.refresh_token
                    },
              headers: { authorization: "Basic #{spotify_api.encoded_credentials}"})

      response = spotify_api.request_refreshed_token(user)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end

  describe '.get_userdata' do
    it 'returns a response object' do
      api_url = 'https://api.spotify.com/v1/me'
      
      stub_request(:get, api_url)
        .with(headers: { authorization: "Bearer #{user.access_token}"})

      response = spotify_api.get_userdata(api_url, user)
      expect(response).to be_a(Faraday::Response)
      expect(response.status).to eql 200
    end
  end
end
