# frozen_string_literal: true

module TrackParser
  def self.get_tracks(api_response)
    @api_response = api_response
    tracks
  end

  def self.parse
    JSON.parse(@api_response)['items']
  end

  def self.tracks
    parse.map do |track|
      Track.new(name: track['track']['name'],
                artist: track['track']['artists'][0]['name'],
                album_link: track['track']['external_urls']['spotify'],
                preview_link: track['track']['preview_url'],
                played_at: track['played_at'])
    end
  end

  private_class_method :parse, :tracks
end
