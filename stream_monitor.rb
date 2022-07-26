require 'rspotify'
require 'pg'
require 'airbrake-ruby'

require_relative 'script_buddy.rb'
include ScriptBuddy
init_constants_from_env %w(
  AIRBRAKE_PROJECT_ID
  AIRBRAKE_API_KEY
  PG_HOST
  PG_PORT
  PG_DB
  PG_USER
  PG_PASSWORD
  SPOTIFY_CLIENT_ID
  SPOTIFY_CLIENT_SECRET
  SPOTIFY_PLAYLIST_ID
)

# Airbrake Error Monitoring
Airbrake.configure do |c|
  c.project_id = AIRBRAKE_PROJECT_ID
  c.project_key = AIRBRAKE_API_KEY
end

# Database Connection
@conn = PG::Connection.new({
  host: PG_HOST,
  port: PG_PORT,
  dbname: PG_DB,
  user: PG_USER,
  password: PG_PASSWORD
})

def record_spotify_data(object_type, id, object_name, popularity)

  # data validation
  raise Exception.new "invalid object_type" unless ['artist', 'track'].include?(object_type)
  raise Exception.new "invalid object id" unless id =~ /[A-Za-z0-9]{22}/
  raise Exception.new "invalid popularity" unless (0..100).include?(popularity)

  @conn.exec("
    INSERT INTO spotify_data_reports (
      uuid,
      external_object_type,
      external_object_id,
      external_object_name,
      popularity,
      created_at,
      updated_at
    )
    VALUES (
      GEN_RANDOM_UUID(),
      '#{object_type}',
      '#{id}',
      '#{object_name}',
      #{popularity},
      NOW(),
      NOW()
    );
  ")
end

RSpotify.authenticate(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET)

artists = []
tracks = []

playlist = RSpotify::Playlist.find_by_id(SPOTIFY_PLAYLIST_ID)

playlist.tracks.each do |track|

  track.artists.each do |artist|
    unless artists.include?(artist.id)
      artists.append(artist.id)
      record_spotify_data('artist', artist.id, artist.name, artist.popularity)
    end
  end

  unless tracks.include?(track.id)
    tracks.append(track.id)
    record_spotify_data('track', track.id, track.name, track.popularity)
  end
end
