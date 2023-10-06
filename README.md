
```
bundle install
bundle exec ruby stream_monitor.rb
```

I suggest asdf for ruby version management: https://asdf-vm.com/

Connect to remote PQL Server via:
```
psql -h [HOSTNAME] -p 5432 -U [USERNAME] -W -d [DATABASENAME]
```

Issue heroku commands:
```
HEROKU_APP=spotify-stream-monitor heroku status
```

---

https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track


The popularity of the artist. The value will be between 0 and
100, with 100 being the most popular. The artist's popularity
is calculated from the popularity of all the artist's tracks.

The popularity of the track. The value will be between 0 and 100,
with 100 being the most popular.

The popularity of a track is a value between 0 and 100, with 100
being the most popular. The popularity is calculated by algorithm
and is based, in the most part, on the total number of plays the
track has had and how recent those plays are.

Generally speaking, songs that are being played a lot now will
have a higher popularity than songs that were played a lot in the
past. Duplicate tracks (e.g. the same track from a single and an
album) are rated independently. Artist and album popularity is
derived mathematically from track popularity. Note: the popularity
value may lag actual popularity by a few days: the value is not
updated in real time.

