20.times do
  Band.create(name: Faker::Lorem.words.join(" "))
end

100.times do
  Album.create(band_id: rand(1..20),
               title: Faker::Lorem.words.join(" "),
               live: ['true', 'false'].sample)
end


1000.times do
  Track.create(album_id: rand(1..100),
               name: Faker::Lorem.words.join(" "),
               bonus: ['true', 'false'].sample,
               lyrics: Faker::Lorem.paragraph)
end
