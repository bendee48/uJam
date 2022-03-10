class UsersController < ApplicationController
  def show
    url = "https://api.spotify.com/v1/me/player/recently-played"
    @shiz = SpotifyApi.get_userdata(url, current_user)
  end
end
