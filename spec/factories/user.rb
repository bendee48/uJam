# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                     { 'emma@email.com' }
    password                  { 'password' }
    access_token              { 'access' }
    refresh_token             { 'refresh' }
    access_token_expiration   { DateTime.new(3000) }

    trait :unauthorised do
      access_token            { nil }
      refresh_token           { nil }
      access_token_expiration { nil }
    end
  end
end
