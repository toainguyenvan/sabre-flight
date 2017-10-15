class Api
	def self.flight_search(from, to, from_date, to_date, token)
		uri = URI("https://api.test.sabre.com/v1/shop/flights")
    params = { "origin" => from, "destination" => to,  "departuredate" => from_date, "returndate" => to_date}
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req_header = {
      "Authorization" => "Bearer " + token,
    }
    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer " + token

		response = http.request(request)

		return response.code, JSON.parse(response.body), response.message
	end
end