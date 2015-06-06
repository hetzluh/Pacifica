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
					popcap, shipGuildSkill, locationX, locationY, playerIsland, devMode)
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
		@devMode = devMode
		@events = Array.new
		@year = 500
		@month = "jan"
		@moon = 1
		@time = -1		
		
		if(@group == 1)
		if @devMode == 1
		@team = "palm"
		else
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
		end		
		elsif(@group == 2)
		if @devMode == 1
		@team = "obsidian"
		else
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
		end		
		elsif(@group == 3)
		if @devMode == 1
		@team = "neutral"
		else
			
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
		end
		elsif(@group == 4)
		if @devMode == 1
		@team = "pearl"
		else
			
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
		end
		elsif(@group == 5)
		if @devMode == 1
		@team = "neutral"
		else
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
		end
		@playerIsland = playerIsland 
		@boatsSent = 0
		@playerState = "default"
		@islandsList = Array.new
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
	
	def biyearlyPay
		payout = @power+@size
		@currentWealth += payout.ceil
	end

	def yearlyPopExplosion
		@population += 4
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

	def think(islands, playerOption, playerState, year, month, moon, time)
		#save copy of islands list
		@islandsList = islands
		#purge non-unique array entries
		@allies.uniq!
		@enemies.uniq!
		#purging enemy allies
		islands.each do |island|
			@allies.each do |ally|
			islands.each do |allyIsland|
				if(allyIsland.getName == ally)
				allyIsland.getAllies.each do |allyAlly|
					@enemies.each do |enemy|
						if allyAlly == enemy
							@allies.delete(ally)
						end
					end
				end
				end
			end
			end
		end
		#purging allies' enemies
		islands.each do |island|
			@allies.each do |ally|
			islands.each do |allyIsland|
				if(allyIsland.getName == ally)
				allyIsland.getEnemies.each do |allyEnemy|
					@allies.each do |ally|
						if allyEnemy == ally
							@allies.delete(ally)
						end
					end
				end
				end
			end
			end
		end

		#setting current time for eventlog
		@year = year
		@month = month
		@moon = moon
		@time = time			
		# Case for AI
		if(@playerIsland == false)
			#sets goal (might need to move into the if clause)
			updateGoal
	
			r = rand(20)
		  	if( r == 19 && @population > @popcap/4 && @currentWealth > 10)	
				r = rand(@allies.size)
				if(@allies.size > 0 && @goal=="TRADING")
					makeTradeBoat(@allies.at(r), @year, @month, @moon, @time)	
					r2 = rand(10)
						if (r2 == 1)	
							newTradePartner(islands)
						end
				elsif(@enemies.size > 0 && @goal=="RAIDING")	
					while(@currentWealth >80)
						if(@enemies.size > 0)
						r = rand(@enemies.size)
						makeWarBoat(@enemies.at(r), @year, @month, @moon, @time)
						break
						elsif(@enemies.size == 0)
						findRandomEnemy(islands)
						end
						
					end
				elsif(@goal=="RETALIATING")
					makeWarBoat(@enemies.at(-1), @year, @month, @moon, @time)
				end
			elsif(r < 2)
				babiesBorn
			end

		# Case for actual player
		elsif(@playerIsland == true)
			if(@playerState == "default")
			elsif(@playerState == "sendingTrade")
				if(playerOption == "-")
				makeTradeBoat("tonga", @year, @month, @moon, @time)
				elsif(playerOption == "=")
				makeTradeBoat("tuamotus", @year, @month, @moon, @time)
				elsif(playerOption == "[")
				makeTradeBoat("rapa nui", @year, @month, @moon, @time)
				elsif(playerOption == "]")
				makeTradeBoat("aotearoa", @year, @month, @moon, @time)
				elsif(playerOption =~ /[0-9]/)
				makeTradeBoat(islands.at(playerOption.to_i).getName, @year, @month, @moon, @time)
				setPlayerState("default")
				end
			elsif(@playerState == "sendingWar")					
				if(playerOption == "-")
				makeWarBoat("tonga", @year, @month, @moon, @time)
				elsif(playerOption == "=")
				makeWarBoat("tuamotus", @year, @month, @moon, @time)
				elsif(playerOption == "[")
				makeWarBoat("rapa nui", @year, @month, @moon, @time)
				elsif(playerOption == "]")
				makeWarBoat("aotearoa", @year, @month, @moon, @time)
				elsif(playerOption =~ /[0-9]/)
				makeWarBoat(islands.at(playerOption.to_i).getName, @year, @month, @moon, @time)	
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

	def findRandomEnemy(islands)
		r = rand(islands.size)
		if(islands.at(r).getName != @name && @allies.include?(islands.at(r).getName) == false && @enemies.include?(islands.at(r).getName) == false)
		addEnemy(islands.at(r).getName)	
		end
	end

	def newTradePartner(islands)
		randomIslandId = rand(13) + 1
		newPartner = islands.at(randomIslandId)
		if(@enemies.include?(newPartner.getName) == false)
		
			addAlly(newPartner.getName)
		end
	end

	def findRandomTradePartner
		r = rand(@allies.length - 1) + 1
		@allies.at(r)
	end

	def babiesBorn
		r = rand(2)
		@population += r	
		if(@population > @popcap)
			@population = @popcap
		end
	end	

	def getEvents
		@events
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

	def makeWarBoat(destinationIslandName, year, month, moon, time)
		warEvent = Event.new(@name, destinationIslandName, ' -attacked- ', 'war', @year, @month, @moon, @time)
		warEvent.write
		@events.push(warEvent)
		@events.uniq!
		#@events.sort_by!{|event| event.getTime}
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
		warBoat = Boat.new(@kingdomId, @name, destinationIslandName, 10, @locationX, @locationY+1, destinationX, destinationY, "war", 0, 						@shipGuildSkill)
		@activeWarBoats.push(warBoat)
		if(@enemies.include?(destinationIslandName) == false)
			addEnemy(destinationIslandName)
		end 
		@boatsSent += 1
	end

	def makeTradeBoat(destinationIslandName, year, month, moon, time)
		tradeEvent = Event.new(@name, destinationIslandName, ' -traded with- ', 'trade', @year, @month, @moon, @time)
		tradeEvent.write		
		@events.push(tradeEvent)
		@events.uniq!
		#@events.sort_by!{|event| event.getTime}
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
		tradeBoat = Boat.new(@kingdomId, @name, destinationIslandName, 5, @locationX, @locationY+1, destinationX, destinationY, "trade", 0, 						@shipGuildSkill)

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
		@allies.each do |ally|
			if ally == kingdomAttacking
				@allies.delete(ally)
			end
		end
		@goal = "RETALIATING"

	end
	
	def addEnemy(island)
		@enemies.push(island)
	end
	
	def addAlly(island)
		enemyAlly = false
		@islandsList.each do |island|
			@allies.each do |ally|
			@islandsList.each do |allyIsland|
				if(allyIsland.getName == ally)
				allyIsland.getEnemies.each do |allyEnemy|
					@allies.each do |ally|
						if allyEnemy == ally
							enemyAlly = true
						end
					end
				end
				end
			end
			end
		end
		if(@allies.size < 4 && enemyAlly == false)
		@allies.push(island)
		end
	end

	def traded(numberCrew, kingdomTrading)
		@population += numberCrew
		@currentWealth += 3
		if(@allies.length < 4 && @enemies.include?(kingdomTrading) == false)
			addAlly(kingdomTrading)
		end
	end

end
#END island.rb
