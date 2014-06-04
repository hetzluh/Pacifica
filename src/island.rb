#!/usr/local/bin/ruby


require 'boat.rb'
require "curses"
include Curses

=begin
This class defines the Kingdom object. All of an island's attributes will be determined here.

Size and appearance will be determined on the map.

Attributes:
kingdomId -> int, used to identify kingdom in back-end
name -> string, name displayed to user
startWealth -> int, amount of currency belonging to a kingdom
currentWealth -> int, current amount, see above
power -> double, 1.0 - 2.0, Modifier used for various purposes
startPopulation -> int, starting population (MAX 10,000)
currentPopulation -> int, current
size -> int, 0-2; 0 is small, size modifier used for various purposes
shipGuildSkill -> int, 1-5, determines boat effectiveness

Hollaaa
=end


class Island

	def initialize(kingdomId, name, size, startWealth, currentWealth, power, population,
					popcap, shipGuildSkill, locationX, locationY)
		#initializing all kingdom attributes
		@kingdomId = kingdomId
		@name = name
		@startWealth = startWealth
		@currentWealth = currentWealth 
		@power = power
		@population = population
		@popcap = popcap
		@shipGuildSkill = shipGuildSkill
		@size = size
		@locationX = locationX
		@locationY = locationY
		@activeTradeBoats = Array.new
		@activeWarBoats = Array.new
	end

	def monthlyPay
		@currentWealth += ((@power*10)+@size)
	end

	def yearlyPopExplosion
		@population += 25
	end

	def think
		r = rand(10)
		if(r > 7 && @population > @popcap/3 && @currentWealth > @startWealth)
			makeTradeBoat("kiribati")
		elsif(r < 2 && @population > @popcap/3 && @currentWealth > @startWealth )
			makeWarBoat("kiribati")
		else
			
		end
	end

	def getId
		@kingdomId
	end
	
	def getName
		@name
	end
	
	def getStartWealth	
		@startWealth
	end
	
	def getCurrentWealth
		@currentWealth
	end
	
	def getPower
		@power
	end
	
	def getPopulation
		@population
	end
		
	def getPopCap
		@popcap
	end

	def getSize
		@size
	end

	def getShipGuildSkill
		@shipGuildSkill
	end

	def getLocationX
		@locationX
	end
	
	def getLocationY
		@locationY
	end

	def getActiveTradeBoats
		@activeTradeBoats
	end

	def getActiveWarBoats
		@activeWarBoats
	end

	def makeWarBoat(destinationIslandName)
		@currentWealth -= 10
		@population -= 10
		if(destinationIslandName == "kiribati")
		destinationX = 4
		destinationY = 6
		end
		warBoat = Boat.new(@kingdomId, 5, @locationX, @locationY, destinationX, destinationY, "war", 				0, @shipGuildSkill)
		@activeWarBoats.push(warBoat)
	end

	def makeTradeBoat(destinationIslandName)
		@currentWealth -= 5
		@population -= 5
		if(destinationIslandName == "kiribati")
		destinationX = 4
		destinationY = 6
		end
		tradeBoat = Boat.new(@kingdomId, 5, @locationX, @locationY, destinationX, destinationY, "trade", 				0, @shipGuildSkill)
		@activeTradeBoats.push(tradeBoat)
	end

end
#END kingdom.rb
