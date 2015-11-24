# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or create!d alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

comedies = Category.create!(name: "TV Comedies")
dramas = Category.create!(name: "TV Dramas")

Video.create!(title: "falmily guy", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/family_guy.jpg", description: "In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.", category: dramas)
Video.create!(title: "monk", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large", description:"Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.", category: dramas)

Video.create!(title: "south park", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/south_park.jpg", description:"Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",category: comedies)
Video.create!(title: "futurama", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/futurama.jpg", description:"Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.", category: comedies)
Video.create!(title: "south park", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/south_park.jpg", description:"Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",category: comedies)
Video.create!(title: "south park", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/south_park.jpg", description:"Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",category: comedies)
Video.create!(title: "south park", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/south_park.jpg", description:"Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",category: comedies)
Video.create!(title: "futurama", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/futurama.jpg", description:"Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.", category: comedies)
Video.create!(title: "futurama", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/futurama.jpg", description:"Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.", category: comedies)
Video.create!(title: "futurama", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/futurama.jpg", description:"Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.", category: comedies)

User.create(email: 'david@test.com', password: 'password', full_name: 'David B')
