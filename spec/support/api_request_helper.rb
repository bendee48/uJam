# frozen_string_literal: true

module ApiRequestHelper
  def stubbed_authorise(state_code, return_response = {})
    client_id = 'cl13nt'
    allow(SpotifyApi).to receive(:state_code).and_return(state_code)
    stub_const("#{SpotifyApi}::CLIENT_ID", client_id)

    stub_request(:get, SpotifyApi::AUTHORIZE_URL)
      .with(query: { client_id: SpotifyApi::CLIENT_ID,
                     response_type: 'code',
                     scope: 'user-read-recently-played',
                     redirect_uri: SpotifyApi::REDIRECT_URL,
                     state: state_code })
      .to_return(return_response)
  end

  def stubbed_request_token(auth_code, return_response = {})
    allow(SpotifyApi).to receive(:encoded_credentials).and_return('credentials')

    stub_request(:post, SpotifyApi::TOKEN_URL)
      .with(body: { grant_type: 'authorization_code',
                    code: auth_code,
                    redirect_uri: SpotifyApi::REDIRECT_URL },
            headers: { authorization: "Basic #{SpotifyApi.encoded_credentials}" })
      .to_return(return_response)
  end
end
