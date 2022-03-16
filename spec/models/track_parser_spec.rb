require 'rails_helper'

RSpec.describe TrackParser, type: :model do
  subject(:parser) { described_class }
  let(:api_response) { File.open('./spec/support/track_data.txt', 'r') { |f| f.read } }
  let(:track_data) { parser.get_tracks(api_response) }
  let(:parsed_track) { track_data.first }
  
  describe '.get_tracks' do
    it 'accepts API response and returns a list of track objects' do
      expect(track_data).to all(be_a(Track)) 
    end

    it 'returns 2 tracks' do
      expect(track_data.size).to eql 2
    end
  end

  describe 'a parsed track contains the correct information' do
    it 'returns correct name' do
      expect(parsed_track.name).to eql 'Disciples'
    end
    
    it 'returns correct artist' do
      expect(parsed_track.artist).to eql 'Tame Impala'      
    end
    
    it 'returns correct album link' do
      expect(parsed_track.album_link).to eql 'https://open.spotify.com/track/2gNfxysfBRfl9Lvi9T3v6R'
    end
    
    it 'returns correct preview link' do
      expect(parsed_track.preview_link).to eql 'https://p.scdn.co/mp3-preview/6023e5aac2123d098ce490488966b28838b14fa2'
    end
    
    it 'returns correct time played' do
      expect(parsed_track.played_at).to eql '2016-12-13T20:44:04.589Z'
    end
  end
end
