# frozen_string_literal: true

# Class for a User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise    :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
  encrypts  :access_token, :refresh_token

  def access_token_valid?
    access_token_expiration > DateTime.now if access_token.present?
  end

  def save_tokens(expires = nil, attributes)
    if expires
      expires = 90 if Rails.env.development? || Rails.env.test? # testing
      date = DateTime.now + expires.seconds
      attributes['access_token_expiration'] = date
    end
    update!(attributes)
  end
end
