#!/usr/local/bin/ruby


require './boat.rb'
require './island.rb'
require "curses"
include Curses

class Event

	def initialize(islandFrom, islandTo, message, type, year, month, moon, time)
		@islandFrom = islandFrom
		@islandTo = islandTo
		@message = message
		@type = type
		@year = year
		@month = month
		@moon = moon
		@eventTime = time
		@eventString = "start"	
	end

	def write
	    	@eventString = "\n#{@moon}/#{@month}/#{@year}: #{@islandFrom.upcase}#{@message}#{@islandTo.upcase}"	
	end

	def getString
	    	@eventString
	end

	def getTime
		@eventTime
	end
end
