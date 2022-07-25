require 'rspotify'
require 'pg'

@conn = PG::Connection.new({
	host: ENV['PG_HOST'],
	port: ENV['PG_PORT'],
	dbname: ENV['PG_DB'],
	user: ENV['PG_USER'],
	password: ENV['PG_PASSWORD']
})

def record_spotify_data(object_type, id, popularity)

	# data validation
	raise Exception.new "invalid object_type" unless ['artist', 'track'].include?(object_type)
	raise Exception.new "invalid id" unless id =~ /[A-Za-z0-9]{22}/
	raise Exception.new "invalid popularity" unless (0..100).include?(popularity)
	
	@conn.exec("
		INSERT INTO spotify_data_reports (
			 uuid,
			 external_object_type,
			 external_object_id,
			 popularity,
			 created_at,
			 updated_at
		)
		VALUES (
			 GEN_RANDOM_UUID(),
			 '#{object_type}',
			 '#{id}',
			 #{popularity},
			 NOW(),
			 NOW()
		);
	")
end

RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

artists = {}
tracks = {}

playlist = RSpotify::Playlist.find_by_id(ENV['SPOTIFY_PLAYLIST_ID'])

playlist.tracks.each do |track|

	track.artists.each do |artist|
		unless artists.key?(artist.id)
			artists[artist.id] = {
				popularity: artist.popularity
			}
			record_spotify_data('artist', artist.id, artist.popularity)
		end
	end

	unless tracks.key?(track.id)
		tracks[track.id] = {
			popularity: track.popularity
		}
		record_spotify_data('track', track.id, track.popularity)
	end
end