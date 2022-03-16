class UsersController < ApplicationController
  def show
    # Check refresh exists to confirm initial authorisation
    if current_user.refresh_token.present?
      if current_user.access_token_valid?
        url = "https://api.spotify.com/v1/me/player/recently-played"
        @response = SpotifyApi.get_userdata(url, current_user)
        @track_items = TrackParser.get_tracks(@response.body)
      else
        @refresh_response = SpotifyApi.request_refreshed_token(current_user)
        @access_token = JSON.parse(@refresh_response.body)['access_token']
        @expires = JSON.parse(@refresh_response.body)['expires_in']
        
        save_access_token

        url = "https://api.spotify.com/v1/me/player/recently-played"
        @response = SpotifyApi.get_userdata(url, current_user)
        @track_items = TrackParser.get_tracks(@response.body)
      end
    end
  end

  private

  def save_access_token
    @expires = 90 if Rails.env.development? || Rails.env.test? #testing
    @date = DateTime.current + @expires.seconds
    current_user.update(access_token: @access_token,
                        access_token_expiration: @date)
  end
end
