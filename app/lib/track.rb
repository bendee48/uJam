# frozen_string_literal: true

Track = Struct.new('Track', :name, :artist, :album_link, :preview_link, :played_at, keyword_init: true)
