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
	Lvl1:	Boat moves 1/3 of the time, hazard kills 7 crew
	2:	Boat moves 1/2 of the time, hazard kills 7 crew
	3:	Boat moves 1/2 of the time, hazard kills 4 crew
	4:	Boat moves 2/3 of the time, hazard kills 4 crew
	5:	Boat moves every time, hazard kills 1 crew
=end


class Island

	def initialize(kingdomId, name, size, startWealth, currentWealth, power, population,
					popcap, shipGuildSkill, locationX, locationY, playerIsland)
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
		#start goal is gather resources
		@goal = "START"
		
		if(@group == 1)
			r = rand(10 + 1) - 1
			if(r < 5)
			@team = "neutral"
			elsif(r > 4 && r < 8)
			@team = "palm"
			elsif(r == 8 || r == 9)
			@team = "pearl"
			elsif(r == 10)
			@team = "obsidian"
			end
		elsif(@group == 2)
			r = rand(10 + 1) - 1
			if(r < 4)
			@team = "obsidian"
			elsif(r == 4)
			@team = "palm"
			elsif(r == 5 || r == 6)
			@team = "pearl"
			elsif(r > 6)
			@team = "neutral"
			end
		elsif(@group == 3)
			r = rand(10 + 1) - 1
			if(r < 5)
			@team = "neutral"
			elsif(r == 5)
			@team = "palm"
			elsif(r == 6 || r == 7)
			@team = "obsidian"
			elsif(r > 7)
			@team = "pearl"
			end
		elsif(@group == 4)
			r = rand(10 + 1) - 1
			if(r < 5)
			@team = "neutral"
			elsif(r == 5 || r == 6)
			@team = "pearl"
			elsif(r == 7 || r == 8)
			@team = "obsidian"
			elsif(r == 9 || r == 10)
			@team = "palm"
			end
		elsif(@group == 5)
			r = rand(10 + 1) - 1
			if(r < 6)
			@team = "neutral"
			elsif(r == 6)
			@team = "obsidian"
			elsif(r == 7 || r == 8)
			@team = "palm"
			elsif(r == 9 || r == 10)
			@team = "pearl"
			end
		end
		@playerIsland = playerIsland 
		@boatsSent = 0
		@playerState = "default"
	end

	def getPlayerState
		@playerState
	end

	def setPlayerState(toSet)
		@playerState = toSet
	end

	def getGoal
		@goal
	end

	def getTeam
		@team
	end

	def setTeam(newTeamName)
		@team = newTeamName
	end		

	def getBoatsSent
		@boatsSent
	end
	
	def monthlyPay
		payout = @power+@size
		@currentWealth += payout.ceil
	end

	def yearlyPopExplosion
		@population += 10
	end

	def getPlayerIsland
		@playerIsland
	end

	def setPlayerIsland(setBool)
		@playerIsland = setBool
	end

	def updateGoal
		if(@population>@popcap/4&&@currentWealth>10)
			if( @currentWealth < 80)
				@goal = "TRADING"
			elsif(@enemies.size > 0 && @currentWealth > 79)
				@goal = "RAIDING"
			end
		end
	end

	def think(islands, playerOption, playerState)
		#purge non-unique array entries
		@allies.uniq!
		@enemies.uniq!

		# Case for AI
		if(@playerIsland == false)
			#sets goal (might need to move into the if clause)
			updateGoal
	
			r = rand(20)
		  	if( r == 19 && @population > @popcap/4 && @currentWealth > 10)	
				r = rand(4)
				if(@allies.size > r && @goal=="TRADING")
					makeTradeBoat(@allies.at(r))	
				elsif(@enemies.size > 0 && @goal=="RAIDING")	
					while(@currentWealth >80)
						r = rand(@enemies.size)
						makeWarBoat(@enemies.at(r))
					end
				elsif(@goal=="RETALIATING")
					makeWarBoat(@enemies.at(-1))
				end
			elsif(r < 2)
				babiesBorn
			end

		# Case for actual player
		elsif(@playerIsland == true)
			if(@playerState == "default")
			elsif(@playerState == "sendingTrade")
				if(playerOption.is_a?(Fixnum))
				makeTradeBoat(islands.at(playerOption.to_i).getName)
				setPlayerState("default")
				end
			elsif(@playerState == "sendingWar")	
				if(playerOption.is_a?(Fixnum))
				makeWarBoat(islands.at(playerOption.to_i).getName)	
				setPlayerState("default")
				end
			end
		end
	end
=begin
When an island prays, it can bring different things. From common to rare:
-Baby boom
-Ship build skill increase
-Typhoons
-Earthquake to an enemy island
etc.
=end
	def pray

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
		r = rand(4)
		@population += r	
		if(@population > @popcap)
			@population = @popcap
		end
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
	
	def setCurrentWealth(plusAmt)
		@currentWealth += plusAmt
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
		@boatsSent += 1
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
		@boatsSent += 1

		if(@boatsSent % 10 == 0 && @shipGuildSkill < 5)
			@shipGuildSkill += 1
		end
	end

	def earthquake
		@population = -1
	end	

	def attacked(numberAttacking, kingdomAttacking)
		@population -= numberAttacking
		@enemies.push(kingdomAttacking)
		@goal = "RETALIATING"

	end
	
	def addEnemy(island)
		@enemies.push(island)
	end
	
	def addAlly(island)
		@allies.push(island)
	end

	def traded(numberCrew, kingdomTrading)
		@population += numberCrew
		@currentWealth += 7
		if(@allies.length < 4 && @enemies.include?(kingdomTrading) == false)
			@allies.push(kingdomTrading)
		end
	end

end
#END island.rb
