require 'rubygems'
require 'twilio-ruby'
require 'debugger'
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
  values ('Kevin Lee', "+17027384649", '30 Tall St.'),
  ('Nirav Chheda', "+15166039356", '12 Chipotle Lane'),
  ('Stephen Roth', "+19145523727", '47 Hooray Ave.'),
  ('Tuan Duong', "+12403771410", '21 Meat Street'),
  ('Sherif Abushadi', "+11383968305", '8 Super Nice Guy Lane');
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


    SMSsender.send_sms_to_user("#{a}, #{b}", user_phone_number)
  end

  def self.send_order(user_phone_number)
    p c = DB1.execute(<<-SQL
    SELECT name, address, phone_number FROM users
    WHERE phone_number = '#{user_phone_number}';
    SQL
    )

    p d = DB1.execute(<<-SQL
    SELECT item FROM orders
    JOIN users ON (orders.user_id = users.id)
    WHERE phone_number = '#{user_phone_number}';
    SQL
    )


    # puts c
    # puts d

    SMSsender.send_sms_to_restaurant("#{c}, #{d}")
  end
end

class Parser

  def self.read_text(user_input = {})
    # p user_input
    # p "hello!"
    user_input_in_array = user_input[:message].downcase.split("\n")
    command = Array.new(1, user_input_in_array.shift)
    # formatted_user_input = user_input_in_array
    user_phone_number = user_input[:phone_number]


    case command
    # when "new"
    #   self.create_new_user(user_input_in_array, user_phone_number)
    when ["show"]
      self.show_usual_order(user_phone_number)
    # when "change"
    #   self.change_usual_order(user_input_in_array, user_phone_number)
    when ["hungry"]
      self.order_from_restaurant(user_phone_number)
    else
      SMSsender.send_sms_to_user("The U'J cannot perform that action.")
    end

  end

  def self.show_usual_order(user_phone_number)
    UjerDatabase.list(user_phone_number)
  end

  def self.order_from_restaurant(user_phone_number)
    UjerDatabase.send_order(user_phone_number)
  end

end

class SMSsender

  def self.send_sms_to_restaurant(output_from_ujerdatabase)

    account_sid = "ACebfdf1512a26dd76959e738d39835611"
    auth_token = "9d8da5e6ffdb46e7ac567638c82f3fa5"
    client = Twilio::REST::Client.new account_sid, auth_token
    from = "+19149025937" # Your Twilio number

    client.account.messages.create(
      :from => from,
      :to => "+19145523727",
      :body => "#{output_from_ujerdatabase}"
    )

  end

  def self.send_sms_to_user(output_from_ujerdatabase, user_phone_number)

    account_sid = "ACebfdf1512a26dd76959e738d39835611"
    auth_token = "9d8da5e6ffdb46e7ac567638c82f3fa5"
    client = Twilio::REST::Client.new account_sid, auth_token
    from = "+19149025937" # Your Twilio number

    client.account.messages.create(
      :from => from,
      :to => user_phone_number,
      :body => "#{output_from_ujerdatabase}"
    )
  end

end

# SMSsender.send_sms_to_restaurant


class SMSReceiver


  def self.run
    account_sid = "ACebfdf1512a26dd76959e738d39835611"
    auth_token = "9d8da5e6ffdb46e7ac567638c82f3fa5"
    @client = Twilio::REST::Client.new account_sid, auth_token

    data = []
    @client.account.messages.list(:to => +9149025937).each do |message|
      data << [message.from, message.body]
    end
    initial_test = data[0]

    while true
      sleep(15)

      data = []

      @client.account.messages.list(:to => +9149025937).each do |message|
        data << [message.from, message.body]
      end

      if data[0] != initial_test

        user_info = {
           phone_number: data[0][0],
           message: data[0][1]
        }

        initial_test = data[0]

        Parser.read_text(user_info)
      end
    end

  end


end

# class Interface

#   def self.prompt
#     puts "Welcome to the U'j!"
#     puts "\nWhat's your number?"
#     user_number = gets.chomp
#     puts "\nType in hungry and press enter to get your food!"
#     user_message = gets.chomp

#     user_info = Hash[[[:number,user_number],[:message,user_message]]]

#     Parser.read_text(user_info)
#   end

# end


SMSReceiver.run
