# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build_stubbed(:user) }

  describe 'validations' do
    context 'is valid with valid attributes' do
      it { is_expected.to be_valid }
    end

    context 'is invalid' do
      it 'is invalid without an email' do
        user.email = nil
        expect(user).to be_invalid
      end
    end
  end

  describe '#access_token' do
    it "returns user's access token" do
      expect(user.access_token).to eql 'access'
    end
  end

  describe '#access_token_valid?' do
    context 'access token has not expired and is valid ' do
      it 'returns true' do
        expect(user.access_token_valid?).to eql true
      end
    end

    context 'access token has expired and is invalid' do
      it 'returns false' do
        user.access_token_expiration = DateTime.now - 60.seconds
        expect(user.access_token_valid?).to eql false
      end
    end
  end

  describe 'save_tokens' do
    let(:user) { create(:user) }

    it 'saves a new access token for the user' do
      user.save_tokens({ access_token: 'new token' })
      expect(user.access_token).to eql 'new token'
    end

    it 'saves a new refresh token' do
      user.save_tokens(refresh_token: 'new refresh')
      expect(user.refresh_token).to eql 'new refresh'
    end

    it 'saves a new access and refresh token at the same time' do
      user.save_tokens(refresh_token: 'new refresh', access_token: 'new access')
      expect(user.refresh_token).to eql 'new refresh'
      expect(user.access_token).to eql 'new access'
    end

    it 'updates access expiration time if new access token is saved' do
      expect { user.save_tokens({ access_token: 'new token' }, 290) }.to change { user.access_token_expiration }
    end
  end
end
