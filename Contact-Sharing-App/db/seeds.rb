# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

andrew = User.create(username: "Andrew")
eddie = User.create(username: "Eddie")
josh = User.create(username: "Josh")
ryan = User.create(username: "Ryan")
Contact.create(name: 'Ned', email: 'ned@example', user_id: 1)
Contact.create(name: 'CJ', email: 'cj@example', user_id: 1)
Contact.create(name: 'Jeff', email: 'jeff@example', user_id: 2)
Contact.create(name: 'David', email: 'david@example', user_id: 2)
Contact.create(name: 'Valina', email: 'valina@example', user_id: 3)
ContactShare.create(user_id: 2, contact_id: 1)
ContactShare.create(user_id: 4, contact_id: 1)
ContactShare.create(user_id: 4, contact_id: 2)
ContactShare.create(user_id: 4, contact_id: 3)
ContactShare.create(user_id: 4, contact_id: 4)
ContactShare.create(user_id: 2, contact_id: 5)
ContactShare.create(user_id: 1, contact_id: 5)
ContactShare.create(user_id: 2, contact_id: 2)
