# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ActiveRecord::Base.transaction do

  User.create(:email => "cj@appacademy.io")
  User.create(:email => "flarnie@appacademy.io")
  User.create(:email => "jeff@appacademy.io")
  User.create(:email => "gsp@appacademy.io")
  User.create(:email => "boss@appacademy.io")

  ShortenedUrl.create_for_user_and_long_url(User.first, 'www.iamcool.com')
  ShortenedUrl.create_for_user_and_long_url(User.last, 'www.iamnotcool.com')

  Visit.record_visit!(User.first, ShortenedUrl.first)
  Visit.record_visit!(User.last, ShortenedUrl.first)
  Visit.record_visit!(User.first, ShortenedUrl.last)
  Visit.record_visit!(User.find_by_id(2), ShortenedUrl.last)
  Visit.record_visit!(User.find_by_id(3), ShortenedUrl.first)
  Visit.record_visit!(User.last, ShortenedUrl.first)
  v = Visit.last
  v.created_at = 2.hours.ago
  v.save
end
