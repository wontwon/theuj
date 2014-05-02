require 'rubygems'
require 'twilio-ruby'


	

class SMSsender

	def self.send_sms_to_restaurant

		account_sid = "ACebfdf1512a26dd76959e738d39835611"
		auth_token = "9d8da5e6ffdb46e7ac567638c82f3fa5"
		client = Twilio::REST::Client.new account_sid, auth_token 
		from = "+19149025937" # Your Twilio number
		 
		restaurants = {
		# "+12403771410" => "Wontwon",
		"+19145523727" => "Stephen",
		}
		restaurants.each do |key, value|
		  client.account.messages.create(
		    :from => from,
		    :to => key,
		    :body => "ORDER AND INFO GOES HERE"
		  ) 
		  puts "Sent order to #{restaurants}.  You should be getting confirmation from them shortly."
		end

	end

end

SMSsender.send_sms_to_restaurant