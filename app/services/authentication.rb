require "base64"

class Authentication
	def self.get_token(username, password)
		# Endcode Base64 username and password
		base64_data = Base64.strict_encode64(username).to_s + ":" + Base64.strict_encode64(password).to_s
		base64_credentials = Base64.strict_encode64(base64_data)

		return send(base64_credentials)
	end

	private
  def self.send(base64_credentials)
    uri = URI("https://api-crt.cert.havail.sabre.com/v2/auth/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req_header = {
      "Authorization" => "Basic " + base64_credentials,
      "Content-Type" => 'application/x-www-form-urlencoded',
      "grant_type" => "client_credentials"
    }
    request = Net::HTTP::Post.new(uri.path, initheader = req_header)
		response = http.request(request)

		return response.code, JSON.parse(response.body), response.message
	end
end