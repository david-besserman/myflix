# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "falmily guy", small_cover_url: "public/tmp/family_guy.jpg", large_cover_url: "public/tmp/family_guy.jpg", description: "In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.")
Video.create(title: "futurama", small_cover_url: "public/tmp/futurama.jpg", large_cover_url: "public/tmp/futurama.jpg", description:"Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.")
Video.create(title: "monk", small_cover_url: "public/tmp/monk.jpg", large_cover_url: "public/tmp/monk_large", description:"Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.")

Video.create(title: "south park", small_cover_url: "public/tmp/south park.jpg", large_cover_url: "public/tmp/south park.jpg", description:"Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.")

Category.create(name: "TV Comedies")
Category.create(name: "TV Dramas")
