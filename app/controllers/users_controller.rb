# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    # Check refresh exists to confirm it's an authorised user
    return unless current_user.refresh_token.present?

    # Request new access token if acess token has expired
    unless current_user.access_token_valid?
      refresh_response = SpotifyApi.request_refreshed_token(current_user)
      access_token = JSON.parse(refresh_response.body)['access_token']
      expires = JSON.parse(refresh_response.body)['expires_in']
      current_user.save_tokens(expires, access_token: access_token)
    end

    url = SpotifyApi::RECENTLY_PLAYED_URL
    response = SpotifyApi.get_userdata(url, current_user)
    @track_items = TrackParser.get_tracks(response.body)
  end
end
