#!/usr/local/bin/ruby


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
	
	def initialize(kingdomId, kingdomName, destinationName, currentCrew, locationX, locationY, destinationX, destinationY, type, spawnTime, shipGuildSkill)
		@kingdomId = kingdomId
		@kingdomName = kingdomName
		@destinationName = destinationName
		@currentCrew = currentCrew
		@locationX = locationX
		@locationY = locationY
		@destinationX = destinationX
		@destinationY = destinationY
		@type = type
		@spawnTime = spawnTime
		@shipGuildSkill = shipGuildSkill
		@dx = locationX - destinationX
		@dy = locationY - destinationY
		@waitOneMoonToDie = false
	end

	def getSpawnTime
		@spawnTime
	end	

	def getDestinationName
		@destinationName
	end

	def getKingdomName
		@kingdomName
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
	
	def getDx
		@dx
	end

	def getDy
		@dy
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
		moveNow = false
		if(@shipGuildSkill == 1)
			moveRand = rand(3 - 1) + 1
			if (moveRand == 2)
				moveNow = true
			end
		elsif(@shipGuildSkill == 2)
			moveRand = rand(3 - 1) + 1
			if (moveRand < 2)
				moveNow = true
			end
		elsif(@shipGuildSkill == 3)
			moveRand = rand(4 - 1) + 1
			if (moveRand < 3)
				moveNow = true
			end
		elsif(@shipGuildSkill == 4)
			moveRand = rand(5 - 1) + 1
			if (moveRand < 4)
				moveNow = true
			end
		elsif(@shipGuildSkill == 5)
			moveNow = true
		end
		if(moveNow == true)
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
		end
		if(@dx == 0 && @dy == 0)
			if(@waitOneMoonToDie == true)
				@currentCrew = 0 
			end
			@waitOneMoonToDie = true
		end
	end

	def damage
		if(@shipGuildSkill == 1)
			@currentCrew -= 7
		elsif(@shipGuildSkill == 2)
			@currentCrew -= 5
		elsif(@shipGuildSkill == 3)
			@currentCrew -= 4
		elsif(@shipGuildSkill == 4)
			@currentCrew -= 3
		elsif(@shipGuildSkill == 1)
			@currentCrew -= 1
		end
	end


end





