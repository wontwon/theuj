def assert_equal(expectation, reality)
  raise "Expected: #{expectation}, got #{reality}." unless expectation == reality
end


class Interface

  def self.prompt
    puts "Welcome to the U'j!"
    puts "\nWhat's your number?"
    user_number = gets.chomp
    puts "\nType in hungry and press enter to get your food!"
    user_message = gets.chomp

    user_info = Hash[[[:number,user_number],[:message,user_message]]]

    Parser.read_text(user_info)
  end

end


Interface.prompt
