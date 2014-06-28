#!/usr/local/bin/ruby


require './boat.rb'
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
		#determining island group to decide probability of alliance placement (later in constructor, defined in src/rules.txt)
		if(@name == "vanuatu" || @name ==  "fiji" || @name == "tuvalu" || @name == "tokelau" || @name == "samoa" || @name == "tonga")
			@group = 1
		elsif(@name == "hawaii" || @name == "aotearoa")
			@group = 2
		elsif(@name == "tuamotus" || @name == "rapa nui")
			@group = 3
		elsif(@name == "tahiti" || @name == "takutea")
			@group = 4
		elsif(@name =="kwajaleins" || @name == "kiribati")
			@group = 5
		end
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
		@enemies = Array.new
		@allies = Array.new
		if(@group == 1)
			r = rand(10 + 1) - 1
			if(r < 5)
			@team = "palm"
			elsif(r > 4 && r < 8)
			@team = "pearl"
			elsif(r == 8 || r == 9)
			@team = "obsidian"
			elsif(r == 10)
			@team = "neutral"
			end
		elsif(@group == 2)
			r = rand(10 + 1) - 1
			if(r < 6)
			@team = "obsidian"
			elsif(r == 6)
			@team = "palm"
			elsif(r == 7)
			@team = "pearl"
			elsif(r > 7)
			@team = "neutral"
			end
		elsif(@group == 3)
			r = rand(10 + 1) - 1
			if(r < 6)
			@team = "pearl"
			elsif(r == 6 || r == 7)
			@team = "palm"
			elsif(r == 8 || r == 9)
			@team = "obsidian"
			elsif(r == 10)
			@team = "neutral"
			end
		elsif(@group == 4)
			r = rand(10 + 1) - 1
			if(r < 4)
			@team = "palm"
			elsif(r > 3 && r < 7)
			@team = "pearl"
			elsif(r > 6  && r < 10)
			@team = "obsidian"
			elsif(r == 10)
			@team = "neutral"
			end
		elsif(@group == 5)
			r = rand(10 + 1) - 1
			if(r < 4)
			@team = "obsidian"
			elsif(r > 3 && r < 7)
			@team = "pearl"
			elsif(r == 7 || r == 8)
			@team = "palm"
			elsif(r == 9 || r == 10)
			@team = "neutral"
			end
		end
	end

	def getTeam
		@team
	end

	def setTeam(newTeamName)
		@team = newTeamName
	end		
	
	def monthlyPay
		@currentWealth += ((@power*10)+@size)
	end

	def yearlyPopExplosion
		@population += 25
	end

	def think(islands)
		#purge non-unique array entries
		@allies.uniq!
		@enemies.uniq!

		r = rand(20)
	    if(@activeWarBoats.size < 2 && @activeTradeBoats.size < 2&& r > 17 && @population > @popcap/3 && @currentWealth > @startWealth-15)
			if(r%2 ==0)
			@allies.each do |partner|
				makeTradeBoat(partner)
			end
			elsif(r%2 == 1)
			@enemies.each do |enemy|
				makeWarBoat(enemy)
			end
			end
		else
			if(r % 9 == 0)
				babiesBorn
			end
		end
	end

	def findRandomEnemy
		r = rand(@enemies.length - 1) + 1
		@enemies.at(r)
	end

	def newTradePartner(islands)
		randomIslandId = rand(13) + 1
		newPartner = islands.at(randomIslandId)
		if(@enemies.include?(newPartner.getName) == false)
			@allies.push(newPartner.getName)
		end
	end

	def findRandomTradePartner
		r = rand(@allies.length - 1) + 1
		@allies.at(r)
	end

	def babiesBorn
		r = rand(3)
		@population += r
	end	

	def getEnemies
		@enemies
	end	

	def getAllies
		@allies
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
		#first purge dead boats
		@activeTradeBoats.each do |boat|
			if(boat.getCurrentCrew == 0)
				boat = nil
			end
		end
		@activeTradeBoats.compact
		@activeTradeBoats
	end

	def getActiveWarBoats
		#first purge dead boats
		@activeWarBoats.each do |boat|
			if(boat.getCurrentCrew == 0)
				boat = nil
			end
		end
		@activeWarBoats.compact
		@activeWarBoats
	end

	def makeWarBoat(destinationIslandName)
		@currentWealth -= 10
		@population -= 10
		if(destinationIslandName == "kiribati")
			destinationX = 7
			destinationY = 8
		elsif(destinationIslandName == "kwajaleins")
			destinationX = 4
			destinationY = 4
		elsif(destinationIslandName == "hawaii")
			destinationX = 32
			destinationY = 4
		elsif(destinationIslandName == "samoa")
			destinationX = 21
			destinationY = 15
		elsif(destinationIslandName == "tokelau")
			destinationX = 15
			destinationY = 11
		elsif(destinationIslandName == "vanuatu")
			destinationX = 4
			destinationY = 15
		elsif(destinationIslandName == "tahiti")
			destinationX = 40
			destinationY = 15
		elsif(destinationIslandName == "takutea")
			destinationX = 33
			destinationY = 14
		elsif(destinationIslandName == "tuvalu")
			destinationX = 10
			destinationY = 9
		elsif(destinationIslandName == "fiji")
			destinationX = 11
			destinationY = 17
		elsif(destinationIslandName == "tonga")
			destinationX = 18
			destinationY = 18
		elsif(destinationIslandName == "tuamotus")
			destinationX = 50
			destinationY = 16
		elsif(destinationIslandName == "rapa nui")
			destinationX = 58
			destinationY = 18
		elsif(destinationIslandName == "aotearoa")
			destinationX = 8
			destinationY = 20
		else
			destinationX = 59
			destinationY = 1
		end
		warBoat = Boat.new(@kingdomId, @name, destinationIslandName, 10, @locationX, @locationY+1, destinationX, destinationY, "war", 0, @shipGuildSkill)
		@activeWarBoats.push(warBoat)
	end

	def makeTradeBoat(destinationIslandName)
		@currentWealth -= 5
		@population -= 5
		if(destinationIslandName == "kiribati")
			destinationX = 7
			destinationY = 8
		elsif(destinationIslandName == "kwajaleins")
			destinationX = 4
			destinationY = 4
		elsif(destinationIslandName == "hawaii")
			destinationX = 32
			destinationY = 4
		elsif(destinationIslandName == "samoa")
			destinationX = 21
			destinationY = 15
		elsif(destinationIslandName == "tokelau")
			destinationX = 15
			destinationY = 11
		elsif(destinationIslandName == "vanuatu")
			destinationX = 4
			destinationY = 15
		elsif(destinationIslandName == "tahiti")
			destinationX = 40
			destinationY = 15
		elsif(destinationIslandName == "takutea")
			destinationX = 33
			destinationY = 14
		elsif(destinationIslandName == "tuvalu")
			destinationX = 10
			destinationY = 9
		elsif(destinationIslandName == "fiji")
			destinationX = 11
			destinationY = 17
		elsif(destinationIslandName == "tonga")
			destinationX = 18
			destinationY = 18
		elsif(destinationIslandName == "tuamotus")
			destinationX = 50
			destinationY = 16
		elsif(destinationIslandName == "rapa nui")
			destinationX = 58
			destinationY = 18
		elsif(destinationIslandName == "aotearoa")
			destinationX = 8
			destinationY = 20
		else
			destinationX = 59
			destinationY = 1
		end
		tradeBoat = Boat.new(@kingdomId, @name, destinationIslandName, 5, @locationX, @locationY+1, destinationX, destinationY, "trade", 0, @shipGuildSkill)

		@activeTradeBoats.push(tradeBoat)
	end

	def earthquake
		@population = -1
	end	

	def attacked(numberAttacking, kingdomAttacking)
		@population -= numberAttacking
		@enemies.push(kingdomAttacking)
	end
	
	def addEnemy(island)
		@enemies.push(island)
	end
	
	def addAlly(island)
		@allies.push(island)
	end

	def traded(numberCrew, kingdomTrading)
		@population += numberCrew
		@currentWealth += 1
		if(@allies.length < 4 && @enemies.include?(kingdomTrading) == false)
			@allies.push(kingdomTrading)
		end
	end

end
#END kingdom.rb
