class Flight
	attr_accessor :segment_1, :segment_2, :base_price, :tax, :total_price
	def initialize(segment_1, segment_2, base_price, tax, total_price)
		self.segment_1 = segment_1
		self.segment_2 = segment_2
		self.base_price = base_price
		self.tax = tax
		self.total_price = total_price
	end
end

