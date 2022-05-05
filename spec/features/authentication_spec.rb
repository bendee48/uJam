require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let(:user) { create(:user, :unauthorised) }
  let(:state_code) { '5tat3c0d3' }

  describe 'authorising Spotify', :api_request_helper do
    context 'user is initially not authorised' do
      it 'returns no access token' do
        sign_in user
        visit root_path

        expect(page).to have_current_path(root_path)
        expect(user.access_token).to eql nil
      end

      it 'shows authorisation button on homepage' do
        sign_in user
        visit root_path

        expect(page).to have_current_path(root_path)
        expect(page).to have_selector('.authorize-btn')
      end

      it 'shows authorisation button on profile page' do
        sign_in user
        visit user_path(user)

        expect(page).to have_current_path(user_path(user))
        expect(page).to have_selector('.authorize-btn')
      end
    end
    
    context 'the authorisation process is successful' do
      it 'authorises user with a valid Spotify account', driver: :mechanize do
        sign_in user
        visit root_path
        auth_code = 'au0th'
        access_token = 'ac355'
        refresh_token = 'r3f3sh'
        
        # Stub Authorize
        response = { headers: {location: callback_path + "?code=#{auth_code}" + "&state=#{state_code}"}}
        stubbed_authorise(state_code, response)

        # Stub Token Request
        response = { body: {access_token: access_token, refresh_token: refresh_token, expires_in: 20}.to_json }
        stubbed_request_token(auth_code, response)
        
        click_link('Authorize Spotify')
        user.reload # Relaod user to show saved changes from db

        expect(page).to have_current_path(root_path)
        expect(page).to_not have_selector('.authorize-btn')
        expect(user.refresh_token).to eql refresh_token
      end
    end

    context 'the authorisation process is unsuccesssful' do
      it "doesn't authorise user if error occurs with Spotify API" do
        sign_in user
        visit root_path

        # Stub authorise
        response = { headers: { location: callback_path + "?error=access_denied" + "&state=#{state_code}"}}
        stubbed_authorise(state_code, response)

        click_link('Authorize Spotify')
        user.reload # Relaod user to show saved changes from db

        expect(page).to have_current_path(root_path)
        expect(page).to have_selector('.authorize-btn')
        expect(page).to have_content('Sorry, something went wrong.')
        expect(user.refresh_token).to eql nil
      end 
    end
  end
end
