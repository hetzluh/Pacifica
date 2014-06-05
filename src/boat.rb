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
	
	def initialize(kingdomId, currentCrew, locationX, locationY, destinationX, destinationY, type, spawnTime, shipGuildSkill)
		@kingdomId = kingdomId
		@currentCrew = currentCrew
		@locationX = locationX
		@locationY = locationY
		@destinationX = destinationX
		@destinationY = destinationY
		@type = type
		@spawnTime = spawnTime
		@shipGuildSkill = shipGuildSkill
		@dx = @locationX - @destinationX
		@dy = @locationY - @destinationY
		@waitOneMoonToDie = false
	end

	def getSpawnTime
		@spawnTime
	end	

	def getShipGuildSkill
		@shipGuildSkill
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
	
	def move
		newRand = rand(10)
		if(newRand % 2 == 0 && (@dx > 0 || @dx < 0))
				if(@dx > 0)
					@locationX -= 1
					@dx -=1
				elsif(@dx < 0)
					@locationX += 1
					@dx += 1
				end	
		elsif(newRand % 2 == 1 && (@dy > 0 || @dy < 0))
				if(@dy > 0)
					@locationY -= 1
					@dy -= 1
				elsif(@dy < 0)
					@locationY += 1
					@dy += 1
				end
		else
			if(@dx != 0)
				if(@dx > 0)
					@locationX -= 1
					@dx -=1
				elsif(@dx < 0)
					@locationX += 1
					@dx += 1
				end	
			end
			if(@dy != 0)
				if(@dy > 0)
					@locationY -= 1
					@dy -=1
				elsif(@dy < 0)
					@locationY += 1
					@dy += 1
				end	
			end
		end	
		if(@dx == 0 && @dy == 0)
			if(@waitOneMoonToDie == true)
				@currentCrew = 0 
			end
			@waitOneMoonToDie = true
		end
	end

	def damage
		if(@shipGuildSkill > 3)
		@currentCrew -= 1
		else
		@currentCrew -= 10
		end
	end


end





