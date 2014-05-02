require 'sqlite3'

DB1 = SQLite3::Database.new "theuj.db"

DB1.execute("drop table if exists users;")
DB1.execute("drop table if exists orders;")
DB1.execute("drop table if exists restaurants;")


DB1.execute(<<-SQL
  CREATE TABLE users
  (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    phone_number VARCHAR(255),
    address VARCHAR(255)
  );
  SQL
  )

DB1.execute(<<-SQL
  CREATE TABLE orders
  (
    id INTEGER PRIMARY KEY,
    item VARCHAR(255),
    user_id INTEGER,
    restaurant_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(restaurant_id) REFERENCES restaurants(id)
  );
  SQL
  )

  DB1.execute(<<-SQL
  CREATE TABLE restaurants
  (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    phone_number VARCHAR(255)
  );
  SQL
  )


DB1.execute(<<-SQL
  insert into users (name, phone_number, address)
  values ('Kevin Lee', '+1516456789', '30 Tall St.'),
  ('Nirav Chheda', '+13857382394', '12 Chipotle Lane'),
  ('Stephen Roth', '+19812347650', '47 Hooray Ave.'),
  ('Tuan Duong', '+12387594000', '21 Meat Street'),
  ('Sherif Abushadi', '+11383968305', '8 Super Nice Guy Lane');
  SQL
)

DB1.execute(<<-SQL
  insert into orders (item, user_id, restaurant_id)
  values ('fried chicken, fries, coke', 1, 1),
  ('vegetarian burrito bowl', 2, 2),
  ('buffalo chicken sandwich', 3, 3),
  ('meeeaaat!!!', 4, 4),
  ('falafel with extra tahini', 5, 5);
  SQL
)

DB1.execute(<<-SQL
  insert into restaurants (name, phone_number)
  values ('KFC', '+15849375901'),
  ('Chipotle', '+19275927583'),
  ('Bomba$$ sandwich place', '+18763458765'),
  ('MEAT WORKS', '+17364839377'),
  ('Falafel Treats $ Other Eats', '+19385783929');
  SQL
)


# p DB1.execute(<<-SQL
#   SELECT * FROM users
#   JOIN thread ON (thread.creator_id = users.id);
#   SQL
#   )

puts "print users table..."
p DB1.execute("select * from users;") # note that sometimes quotes are enough
puts ""

puts "print orders table..."
p DB1.execute("select * from orders;") 
puts ""

puts "print restaurants table..."
p DB1.execute("select * from restaurants;") 
puts ""

puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"


class UjerDatabase
  def self.list(user_phone_number)
    a = DB1.execute(<<-SQL
    SELECT item FROM orders
    JOIN users ON (orders.user_id = users.id)
    WHERE phone_number = '#{user_phone_number}';
    SQL
    )

    b = DB1.execute(<<-SQL
    SELECT name FROM restaurants
    JOIN orders ON (restaurants.id = orders.restaurant_id)
    WHERE item = '#{a}';
    SQL
    )
  end

  def self.send_order(user_phone_number)
    c = DB1.execute(<<-SQL
    SELECT name, address, phone_number FROM users
    WHERE phone_number = '#{user_phone_number}';
    SQL
    )

    d = DB1.execute(<<-SQL
    SELECT item FROM orders
    JOIN users ON (orders.user_id = users.id)
    WHERE phone_number = '#{user_phone_number}';
    SQL
    )
  end
end

UjerDatabase.list('+13857382394')
UjerDatabase.send_order('+13857382394')
