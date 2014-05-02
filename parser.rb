class Parser

	def self.read_text(user_input = {})

		user_input_in_array = user_input[:message].split("\n")
		command = Array.new(1, user_input_in_array.pop)
		# formatted_user_input = user_input_in_array
		user_phone_number = user_input[:number]


		case command
		# when "new"
		# 	self.create_new_user(user_input_in_array, user_phone_number)
		when "show"
			self.show_usual_order(user_phone_number)
		# when "change"
		# 	self.change_usual_order(user_input_in_array, user_phone_number)
		when "hungry"
			self.order_from_restaurant(user_phone_number)
		else
			SMSsender.send_sms_to_user("The U'J cannot perform that action.")
		end

	end

	# def self.create_new_user(user_input_in_array)
		
	# 	UjerDatabase.create(name, address, user_phone_number, order)
	# end

	def self.show_usual_order(user_phone_number)
		UjerDatabase.list(user_phone_number)
	end

	def self.order_from_restaurant(user_phone_number)
		UjerDatabase.send_order(user_phone_number)
	end

end