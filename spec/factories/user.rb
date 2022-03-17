# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                     { 'emma@email.com' }
    password                  { 'password' }
    access_token              { 'access' }
    access_token_expiration   { DateTime.new(3000) }

    trait :unauthorised do
      access_token { nil }
    end
  end
end
