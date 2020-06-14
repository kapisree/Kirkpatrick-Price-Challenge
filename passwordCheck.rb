# Gems needed to access the Web Service
require "net/https"
require "uri"

# Password Checker Class to check given password against Have I Been Pwned database
class PasswordChecker

	# Method to check the password
	# Parameter - password as text
	def checkPassword pwd 

		# validate password is not blank or empty
		if pwd.strip.length == 0
			raise ArgumentError, 'Password cannot be blank or empty.'
		end

		foundPassword = false
		
		#Get the SHA1 hash for the password
		pwd_sha1_hash = Digest::SHA1.hexdigest(pwd)
		
		# Call the web service and pass the hash
		response = callWebService pwd_sha1_hash
		if response.kind_of?(Net::HTTPOK)
			foundPassword = true
		end
		
		return foundPassword
	end
	
	def callWebService pwd_hash
	
		puts "Password Hash: #{pwd_hash}"   
		uri = URI("https://api.pwnedpasswords.com/range/#{pwd_hash[0..4]}")
		http = Net::HTTP.new(uri.host, uri.port)
		# Ease HTTPS parameters 
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE	
		
		#Call the service
		request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => 'KirkpatrickPrice_Challange application - Testing the password API service.'})
		res = http.request(request)
		#puts "Response Code:  #{res.code}"
		return res
	end

end
