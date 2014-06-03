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
	
	def initialize(kingdomId, currentCrew, locationX, locationY, destinationX, destinationY, type, spawnTime)
		@kingdomId = kingdomId
		@currentCrew = currentCrew
		@locationX = locationX
		@locationY = locationY
		@destinationX = destinationX
		@destinationY = destinationY
		@type = type
		@spawnTime = spawnTime
	end

	def getSpawnTime
		@spawnTime
	end	

	def getKingdomId
		@kingdomId
	end
	
	def getCurrentCrew
		@currentCrew
	end
	
	def getLocationX
		@locationX
	end

	def getLocationY
		@locationY
	end

	def getType
		@type
	end
	
	def move (startX, startY, endX, endY)
		dx = @locationX - @destinationX
		dy = @locationy - @destinationY
		while(dx > 0 || dy > 0)
		switch = 0
		if(switch == 0 && dx > 0)
		@locationX -= 1 
		dx -= 1
		switch = 1
		elsif(switch == 1 && dy > 0)
		@locationY -= 1
		dy -= 1
		else
		if(dx == 0)
		@locationX -= 1 
		dx -= 1
		elsif(dy == 0)
		@locationY -= 1
		dy -= 1
		end
		end
		end
	end




end





