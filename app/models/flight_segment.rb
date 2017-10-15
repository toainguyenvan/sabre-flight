class FlightSegment
	attr_accessor :code, :number, :departure_airport, :departure_date, :arrival_airport, :arrival_date
	def initialize(code, number, departure_airport, departure_date, arrival_airport, arrival_date)
		self.code = code
		self.number = number
		self.departure_airport = departure_airport
		self.departure_date = departure_date
		self.arrival_airport = arrival_airport
		self.arrival_date = arrival_date
	end
end