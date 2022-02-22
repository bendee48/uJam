# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static#homepage'
  devise_for :users
end
