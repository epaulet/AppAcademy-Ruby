User.create(
  user_name: 'tripp',
  password: 'davis'
)
User.create(
  user_name: 'eddie',
  password: 'paulet'
)
User.create(
  user_name: 'cat_lover',
  password: 'luvcats'
)
User.create(
  user_name: 'roger',
  password: 'roger'
)

Cat.create(
  birth_date: Date.new(2005, 5, 16),
  color: 'calico',
  name: 'Mittens',
  gender: 'F',
  description: 'Very nice cat!',
  user_id: 2
)
Cat.create(
  birth_date: Date.new(2010, 11, 20),
  color: 'white',
  name: 'Bob',
  gender: 'M',
  description: 'Really chill',
  user_id: 1
)
Cat.create(
  birth_date: Date.new(2001, 2, 1),
  color: 'brown',
  name: 'Grumpy',
  gender: 'M',
  description: 'Kind of sucks',
  user_id: 1
)
CatRentalRequest.create(
  cat_id: 1,
  user_id: 1,
  start_date: Date.new(2015, 3, 10),
  end_date: Date.new(2015, 3, 20)
)
CatRentalRequest.create(
  cat_id: 1,
  user_id: 3,
  start_date: Date.new(2015, 3, 15),
  end_date: Date.new(2015, 3, 30)
)
CatRentalRequest.create(
  cat_id: 1,
  user_id: 1,
  start_date: Date.new(2015, 3, 5),
  end_date: Date.new(2015, 3, 7)
)
CatRentalRequest.create(
  cat_id: 1,
  user_id: 1,
  start_date: Date.new(2015, 4, 10),
  end_date: Date.new(2015, 4, 20)
)
CatRentalRequest.create(
  cat_id: 1,
  user_id: 4,
  start_date: Date.new(2015, 3, 10),
  end_date: Date.new(2015, 4, 10)
)
CatRentalRequest.create(
  cat_id: 2,
  user_id: 2,
  start_date: Date.new(2016, 3, 10),
  end_date: Date.new(2016, 4, 10)
)
CatRentalRequest.create(
  cat_id: 2,
  user_id: 3,
  start_date: Date.new(2015, 10, 3),
  end_date: Date.new(2015, 10, 5)
)
CatRentalRequest.create(
  cat_id: 3,
  user_id: 4,
  start_date: Date.new(2015, 5, 5),
  end_date: Date.new(2015, 5, 15)
)
