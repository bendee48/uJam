require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let(:user) { create(:user, :unauthorised) }

  describe 'authorising Spotify' do
    context 'currently unauthorised user' do
      it 'returns no access token' do
        sign_in user
        visit root_path

        expect(page).to have_current_path(root_path)
        expect(user.access_token).to eql nil
      end

      it 'shows authoriztion button on homepage' do
        sign_in user
        visit root_path

        expect(page).to have_current_path(root_path)
        expect(page).to have_selector('.authorize-btn')
      end

      it 'shows authorization button on profile page' do
        sign_in user
        visit user_path(user)

        expect(page).to have_current_path(user_path(user))
        expect(page).to have_selector('.authorize-btn')
      end
    end
    
    it 'authorises user with a valid Spotify account', driver: :mechanize do
      sign_in user
      visit root_path

      # Stub Authorize
      allow(SpotifyApi).to receive(:state_code).and_return('state code')
      stub_const("#{SpotifyApi}::CLIENT_ID", '12345')
      stub_request(:get, SpotifyApi::AUTHORIZE_URL)
        .with(query: { client_id: SpotifyApi::CLIENT_ID,
                       response_type: 'code',
                       scope: 'user-read-recently-played',
                       redirect_uri: SpotifyApi::REDIRECT_URL,
                       state: 'state code' })
        .to_return({ headers: {location: callback_path + "?code=12345" + "&state=state%20code"} })

      # Stub Token Request
      allow(SpotifyApi).to receive(:encoded_credentials).and_return('credentials')
      stub_request(:post, SpotifyApi::TOKEN_URL)
        .with(body: { grant_type: 'authorization_code',
                      code: '12345',
                      redirect_uri: SpotifyApi::REDIRECT_URL },
              headers: { authorization: "Basic #{SpotifyApi.encoded_credentials}" })
        .to_return({ body: {access_token: '1234', refresh_token: '5678', expires_in: 20}.to_json })

      click_link('Authorize Spotify')
      user.reload # Relaod user to show saved changes from db

      expect(page).to have_current_path(root_path)
      expect(page).to_not have_selector('#authorize-btn')
      expect(user.refresh_token).to eql '5678'      
    end
  end
end
