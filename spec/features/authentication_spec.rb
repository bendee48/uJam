require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let(:user) { create(:user, :unauthorised) }

  describe 'authorising Spotify' do
    context 'user is not authorised' do
      it 'returns no access token for an unauthorised user' do
        sign_in user
        visit root_path

        expect(page).to have_current_path(root_path)
        expect(user.access_token).to eql nil
      end
    end
  end
end
