# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise    :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
  encrypts  :access_token, :refresh_token

  def access_token_valid?
    access_token_expiration > DateTime.now if access_token.present?
  end
end
