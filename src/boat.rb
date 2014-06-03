#!/usr/local/bin/ruby


require "curses"
include Curses

=begin
This class defines the Boat object. 

A boat can be a trade boat: T
Or a war boat: W

Attributes:
kingdomId -> int, kingdom belonging to boat
currentCrew -> int, current crew number
War boats begin with 10.
Trade boats begin with 5.
*** On war boat, 3 crew must survive or the boat will perish ***
*** On trade boat, 2 crew must survive or the boat will perish **

Hollaaa
=end


class Boat
	
	def initialize(kingdomId, currentCrew, locationX, locationY, type)
		@kingdomId = kingdomId
		@currentCrew = currentCrew
		@locationX = locationX
		@locationY = locationY
		@type = type
	end

	def getKingdomId
		@kingdomId
	end
	
	def getCurrentCrew
		@currentCrew
	end
	
	def getType
		@type
	end
	
	def sail (startX, startY, endX, endY)
		#defines the boat's sailing movements
	end




end





