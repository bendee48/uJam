# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Track, type: :model do
  subject(:track) { build(:track) }

  describe '#name' do
    it 'returns the name of the track' do
      expect(track.name).to eql 'track 1'
    end
  end

  describe '#artist' do
    it 'returns the artist of the track' do
      expect(track.artist).to eql 'artist 1'
    end
  end

  describe '#album_link' do
    it 'returns the album link for the track' do
      expect(track.album_link).to eql 'album_link'
    end
  end

  describe '#preview_link' do
    it 'returns the preview link for the track' do
      expect(track.preview_link).to eql 'preview_link'
    end
  end

  describe '#played_at' do
    it 'returns the time the track was played' do
      expect(track.played_at).to eql '5 minutes ago'
    end
  end
end
