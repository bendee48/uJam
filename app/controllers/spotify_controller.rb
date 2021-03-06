# frozen_string_literal: true

class SpotifyController < ApplicationController
  before_action :auth_code, only: [:callback]
  before_action :returned_state_code, only: [:callback]

  def authorize
    state = SpotifyApi.state_code
    session[:state_code] = state
    response = SpotifyApi.authorize(state)

    # Redirect to #callback
    redirect_to response.env.response_headers[:location], allow_other_host: true
  end

  def callback
    # Check state code matches and that an auth code has been returned
    if @returned_state_code == session[:state_code] && params[:code]
      response = SpotifyApi.request_token(@auth_code)
      access_token = JSON.parse(response.body)['access_token']
      refresh_token = JSON.parse(response.body)['refresh_token']
      expires = JSON.parse(response.body)['expires_in']

      current_user.save_tokens({ access_token: access_token, refresh_token: refresh_token }, expires)

      flash.notice = 'Successfully authorised.'
    else
      flash.alert = 'Sorry, something went wrong. Authorisation terminated.'
    end

    redirect_to root_path
  end

  private

  def auth_code
    @auth_code = params[:code]
  end

  def returned_state_code
    @returned_state_code = params[:state]
  end
end
