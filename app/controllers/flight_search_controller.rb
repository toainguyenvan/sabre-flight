class FlightSearchController < ApplicationController
	layout 'application'
	before_action :authenticate_user
	
	def index
		if request.post?
			# Call Flight Search API
			code, data, message = Api.flight_search(params[:from], params[:to], params[:from_date], params[:to_date], current_user.token)
			
			mapped_data = []
			if code == '200'
				json_data =  data
				
				json_data["PricedItineraries"].each do |item|
					# Flight Segments
					segments = []
					
					item["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"].each do |flight|
						code = flight["FlightSegment"][0]["OperatingAirline"]["Code"]
						number = flight["FlightSegment"][0]["OperatingAirline"]["FlightNumber"]
						departure_airport = flight["FlightSegment"][0]["DepartureAirport"]["LocationCode"]
						departure_date = flight["FlightSegment"][0]["DepartureDateTime"]
						arrival_airport = flight["FlightSegment"][0]["ArrivalAirport"]["LocationCode"]
						arrival_date = flight["FlightSegment"][0]["ArrivalDateTime"]

						flight_segment = FlightSegment.new(code, number, departure_airport, departure_date, arrival_airport, arrival_date)
						segments << flight_segment
					end

					# Price
					base_price = item["AirItineraryPricingInfo"]["ItinTotalFare"]["BaseFare"]["Amount"]
					tax = item["AirItineraryPricingInfo"]["ItinTotalFare"]["Taxes"]["Tax"][0]["Amount"]
					total_price = item["AirItineraryPricingInfo"]["ItinTotalFare"]["TotalFare"]["Amount"]

					flight_data = Flight.new(segments[0], segments[1], base_price, tax, total_price)

					mapped_data << flight_data
				end
			end

			@mapped_data = mapped_data
			@from = params[:from]
			@to = params[:to]
			@from_date = params[:from_date]
			@to_date = params[:to_date]
		end
	end

	private
	def authenticate_user
  	redirect_to sign_in_path unless current_user
  end
end