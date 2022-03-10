FactoryBot.define do
  factory :track do
    name         { 'track 1' }
    artist       { 'artist 1' }
    album_link   {'album_link' }
    preview_link {'preview_link' }
    played_at    { '5 minutes ago' }
  end
end
