require 'rubygems'
require 'twilio-ruby'


	

class SMSsender

	def self.send_sms_to_restaurant(output_from_ujerdatabase)

		account_sid = "ACebfdf1512a26dd76959e738d39835611"
		auth_token = "9d8da5e6ffdb46e7ac567638c82f3fa5"
		client = Twilio::REST::Client.new account_sid, auth_token 
		from = "+19149025937" # Your Twilio number

	  client.account.messages.create(
	    :from => from,
	    :to => "+19145523727",
	    :body => output_from_ujerdatabase
	  )

	end

	def self.send_sms_to_user(output_from_ujerdatabase)

		account_sid = "ACebfdf1512a26dd76959e738d39835611"
		auth_token = "9d8da5e6ffdb46e7ac567638c82f3fa5"
		client = Twilio::REST::Client.new account_sid, auth_token 
		from = "+19149025937" # Your Twilio number

	  client.account.messages.create(
	    :from => from,
	    :to => "+19145523727",
	    :body => output_from_ujerdatabase
	  ) 
	end

end

# SMSsender.send_sms_to_restaurant
