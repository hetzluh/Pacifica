#!/usr/local/bin/ruby


require 'island.rb'
require 'boat.rb'
require 'earthquake.rb'
require 'tsunami.rb'
require 'typhoon.rb'

require "curses"
include Curses

=begin
This class is the simulation's main script
lines = 31, cols = 113
top left = (1, 6)
=end

class Pacifica
	def initialize()
		@currentTime = 0
		@islands = Array.new
		@objects = Array.new
		@currentTsunamis = Array.new
		@hazardLocationsX = Array.new
		@hazardLocationsY = Array.new
		@epicenterLocationsX = Array.new
		@epicenterLocationsY = Array.new
		@year = 500
		@moon = 1
		@month = "jan"
	end

	def clearHazards
		@hazardLocationsX.clear
		@hazardLocationsY.clear
	end

	def addObject(object)
		@objects.push(object)
	end
	
	def getCurrentTime
		@currentTime
	end

	def setCurrentTime(timeSetTo)
		@currentTime = timeSetTo
	end
	
	def getCurrentTsunamis
		@currentTsunamis
	end
	
	def getYear
		@year
	end

	def setYear(yearSetTo)
		@year = yearSetTo
	end
	
	def getMonth
		@month
	end

	def setMonth(monthSetTo)
		@month = monthSetTo
	end

	def getIslands
		@islands
	end
	
	def setObjects(objArr)
		@objects = objArr
	end

	def getObjects
		@objects
	end

	def addEpicenterX(loc)
		@epicenterLocationsX.push(loc)
	end
	
	def addEpicenterY(loc)
		@epicenterLocationsY.push(loc)
	end

	def addHazardX(haz1, haz2, haz3, haz4, haz5, haz6, haz7, haz8, haz9, haz10, haz11)
		@hazardLocationsX.push(haz1, haz2, haz3, haz4, haz5, haz6, haz7, haz8, haz9, haz10, haz11)	
		@hazardLocationsX.compact
	end

	def addHazardY(haz1, haz2, haz3, haz4, haz5, haz6, haz7, haz8, haz9)
		@hazardLocationsY.push(haz1, haz2, haz3, haz4, haz5, haz6, haz7, haz8, haz9)	
		@hazardLocationsY.compact
	end

	def addIslands
=begin
		Reminder: (kingdomId, name, size, startWealth, currentWealth, power, population
					popcap, shipGuildSkill, locationX, locationY)
=end
		kiribati = Island.new(1, "kiribati", 1, 50, 50, 1.2, 15, 70, 1, 7, 8)
		kwajaleins = Island.new(2, "kwajaleins", 1, 50, 50, 1.2, 15, 70, 1, 4, 5)
		hawaii   = Island.new(3, "hawaii", 2, 60, 60, 1.6, 85, 85, 2, 32, 3)
		samoa    = Island.new(4, "samoa", 0, 40, 40, 1.4, 15, 70, 1, 21, 14)
		tokelau  = Island.new(5, "tokelau", 0, 30, 30, 1.3, 10, 60, 2, 15, 12)
		vanuatu  = Island.new(6, "vanuatu", 1, 35, 35, 1.4, 15, 70, 1, 4, 14)
		tahiti 	 = Island.new(7, "tahiti", 0, 40, 40, 1.3, 25, 60, 3 , 40, 14)
		takutea	 = Island.new(8, "takutea", 0, 40, 40, 1.3, 25, 60, 3, 33, 15)
		tuvalu	 = Island.new(9, "tuvalu", 0, 35, 35, 1.3, 10, 60, 2, 10, 10)
		fiji	 = Island.new(10, "fiji", 1, 40, 40, 1.3, 15, 70, 1,  11, 16)
		tonga    = Island.new(11, "tonga", 0, 35, 35, 1.3, 10, 60, 2, 18, 17)
		tuamotus = Island.new(12, "tuamotus", 1, 40, 40, 1.3, 15, 70, 3, 50, 15)
		rapanui  = Island.new(13, "rapa nui", 1, 55, 55, 1.5, 15, 75, 4, 58, 17)
		aotearoa = Island.new(14, "aotearoa", 2, 55, 55, 1.6, 20, 85, 3, 6, 21)

		@islands.push(kiribati, kwajaleins, hawaii, samoa, tokelau,
						vanuatu, tahiti, takutea, tuvalu, fiji, tonga,
							tuamotus, rapanui, aotearoa)
	end

	def make_game_window(islands, objects, month, year, time)
	  win = Window.new(24, 64, ((lines-25)/2)-2, (cols-100)/2)
	  win.box(?|, ?-)
		@moon = (time+1)%10
		if @moon == 0
			@moon = 10
		end
		moon = @moon
   	    win.addstr("Moon: #{moon}, Month: #{month}, Year: #{year}")
		
	
		@islands.each do |island|
			y = island.getLocationY
			x = island.getLocationX
			landEqX = false
			landEqY = false 
				@epicenterLocationsX.each do |eq|
					if(island.getLocationX == eq)
						landEqX = true
					end
				end
				if(landEqX == true)
					@epicenterLocationsY.each do |eq|
						if(island.getLocationY == eq)
							landEqY = true
						end
					end
				end
				if(landEqY == true)
					island.earthquake
					landEqX = false
					landEqY = false 
				end
			win.setpos(y, x)

			#Kingdom-specific graphics start now
			if (island.getName == "kiribati")
				win.addstr("*")
				win.setpos(y -1, x)
				win.addstr(".")
			end
	
			if (island.getName == "kwajaleins")
				win.addstr("*")
				win.setpos(y, x-1)
				win.addstr("'")
			end
	
			if (island.getName == "hawaii")
				win.addstr("*O")
				win.setpos(y-1, x-1)
				win.addstr(",")
				win.setpos(y-1, x -3)
				win.addstr(".")
				win.setpos(y-1, x-5)
				win.addstr("'")
			end
			
			if (island.getName == "samoa")
				win.addstr("*")
				win.setpos(y, x-1)
				win.addstr("o")
			end
	
			if (island.getName == "tokelau")
				win.addstr("*")
				win.setpos(y-1, x-1)
				win.addstr(".")
			end
	
			if (island.getName == "tuvalu")
				win.addstr("*")
				win.setpos(y, x+1)
				win.addstr(".")
				win.setpos(y, x-1)
				win.addstr("'")
			end
	
			if (island.getName == "vanuatu")
				win.addstr("*")
				win.setpos(y, x+1)
				win.addstr(".")
				win.setpos(y, x+2)
				win.addstr("o")
			end
	
			if (island.getName == "fiji")
				win.addstr("*")
				win.setpos(y-1, x+1)
				win.addstr(",")
				win.setpos(y, x-1)
				win.addstr("'")
			end
	
			if (island.getName == "tonga")
				win.addstr("*")
				win.setpos(y-1, x)
				win.addstr(".")
			end
	
			if (island.getName == "takutea")
				win.addstr("*")
			end
	
			if (island.getName == "tahiti")
				win.addstr("*")
			end
			
			if (island.getName == "tuamotus")
				win.addstr("*")
				win.setpos(y, x+2)
				win.addstr(",")
				win.setpos(y-1, x-1)
				win.addstr(".")
				win.setpos(y+1, x+1)
				win.addstr("'")
			end
	
			if (island.getName == "rapa nui")
				win.addstr("* o")
			end
			
			if (island.getName == "aotearoa")
				win.addstr("oo*")
				win.setpos(y-1, x-1)
				win.addstr(".")
				win.setpos(y+1, x-1)
				win.addstr("ooo")
			end
			#End kingdom graphics
		end

	random_earthquake_generator
	random_typhoon_generator	

		@objects.each do |object|
			y = object.getLocationY
			x = object.getLocationX
			boatHitX = false
			boatHitY = false
			win.setpos(y, x)
			if(object.class.name == "Earthquake")
				win.addstr("E")
			elsif(object.class.name == "Boat")
				#if boat has arrived at destination, effect happens				
				if(object.getDx == 0 && object.getDy == 0)
					if(object.getType == "war")
						if(object.getDestinationName == "kiribati")
							@islands.at(0).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "kwajaleins")
							@islands.at(1).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "hawaii")
							@islands.at(2).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "samoa")
							@islands.at(3).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "tokelau")
							@islands.at(4).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "vanuatu")
							@islands.at(5).attacked(object.getCurrentCrew, object.getKingdomName)				
						elsif(object.getDestinationName == "tahiti")
							@islands.at(6).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "takutea")
							@islands.at(7).attacked(object.getCurrentCrew, object.getKingdomName)			
						elsif(object.getDestinationName == "tuvalu")
							@islands.at(8).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "fiji")
							@islands.at(9).attacked(object.getCurrentCrew, object.getKingdomName)				
						elsif(object.getDestinationName == "tonga")
							@islands.at(10).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "tuamotus")
							@islands.at(11).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "rapa nui")
							@islands.at(12).attacked(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "aotearoa")
							@islands.at(13).attacked(object.getCurrentCrew, object.getKingdomName)
						end
					elsif(object.getType == "trade")
						if(object.getDestinationName == "kiribati")
							@islands.at(0).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "kwajaleins")
							@islands.at(1).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "hawaii")
							@islands.at(2).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "samoa")
							@islands.at(3).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "tokelau")
							@islands.at(4).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "vanuatu")
							@islands.at(5).traded(object.getCurrentCrew, object.getKingdomName)				
						elsif(object.getDestinationName == "tahiti")
							@islands.at(6).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "takutea")
							@islands.at(7).traded(object.getCurrentCrew, object.getKingdomName)			
						elsif(object.getDestinationName == "tuvalu")
							@islands.at(8).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "fiji")
							@islands.at(9).traded(object.getCurrentCrew, object.getKingdomName)				
						elsif(object.getDestinationName == "tonga")
							@islands.at(10).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "tuamotus")
							@islands.at(11).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "rapa nui")
							@islands.at(12).traded(object.getCurrentCrew, object.getKingdomName)
						elsif(object.getDestinationName == "aotearoa")
							@islands.at(13).traded(object.getCurrentCrew, object.getKingdomName)
						end
					end
				end
				#display boat and decide whether it has been damaged
				if(object.getType == "trade")
					win.addstr("T")
				elsif(object.getType == "war")
					win.addstr("W")
				end
				@hazardLocationsX.each do |hazard|
					if(object.getLocationX == hazard)
						boatHitX = true
					end
				end
				if(boatHitX == true)
					@hazardLocationsY.each do |hazard|
						if(object.getLocationY == hazard)
							boatHitY = true
						end
					end
				end
				if(boatHitY == true)
					object.damage
				end
			elsif(object.class.name == "Typhoon")
			win.addstr("@")
				if(object.getSize == 1 || object.getSize == 2 || object.getSize == 3)
					win.setpos(y, x-1)
					win.addstr("(")
					win.setpos(y, x+1)
					win.addstr(")")
				end
				if(object.getSize == 2 || object.getSize == 3)
					win.setpos(y, x-2)
					win.addstr("(")
					win.setpos(y, x+2)
					win.addstr(")")
					win.setpos(y-1, x)
					win.addstr("^")
					win.setpos(y+1, x)
					win.addstr("v")
				end
				if(object.getSize == 3)
					win.setpos(y, x-3)
					win.addstr("(")
					win.setpos(y, x+3)
					win.addstr(")")
					win.setpos(y-1, x-1)
					win.addstr("-")
					win.setpos(y-1, x)
					win.addstr("-")
					win.setpos(y-1, x+1)
					win.addstr("-")
					win.setpos(y+1, x-1)
					win.addstr("-")
					win.setpos(y+1, x)
					win.addstr("-")
					win.setpos(y+1, x+1)
					win.addstr("-")
					win.setpos(y-2, x)
					win.addstr("^")
					win.setpos(y+2, x)
					win.addstr("v")
				end
			elsif(object.class.name == "Tsunami")
			win.addstr("~")
				if(object.getSize == 1 || object.getSize == 2 || object.getSize == 3 ||
					object.getSize == 4 || object.getSize == 5)
					win.setpos(y, x-1)
					win.addstr("~")
					win.setpos(y, x+1)
					win.addstr("~")
				end
				if(object.getSize == 2 || object.getSize == 3 || object.getSize == 4 || object.getSize == 5)
					win.setpos(y, x-2)
					win.addstr("~")
					win.setpos(y, x+2)
					win.addstr("~")
				end
				if(object.getSize == 3 || object.getSize == 4 || object.getSize == 5)
					win.setpos(y, x-3)
					win.addstr("~")
					win.setpos(y, x+3)
					win.addstr("~")
				end
				if(object.getSize == 4 || object.getSize == 5)
					win.setpos(y, x-4)
					win.addstr("~")
					win.setpos(y, x+4)
					win.addstr("~")
				end
				if(object.getSize == 5)
					win.setpos(y, x-5)
					win.addstr("~")
					win.setpos(y, x+5	)
					win.addstr("~")
				end
			end	
		end
		
	
	  win.refresh
	  
	  handle_objects(@objects)
	  handle_kingdoms(@islands)
	 win.close
	end
	
	def	handle_objects(objects)
		@objects.each do |object|
			if(!(object.class.name == "Earthquake"))
			object.move	
			end
		end
	end
	
	def random_earthquake_generator
		prob = rand(100)
		if(prob%4 == 0)
		epiX = rand(50 - 3) +3
		epiY = rand(18 - 1) +1
		sz = rand(4-1) + 1
		earthquake1 = Earthquake.new(sz, epiX, epiY, @currentTime)
		earthquake1.spawnTsunamis
			earthquake1.getTsunamisList.each do |tsunami|
				addObject(tsunami)
			end
		addObject(earthquake1)
		elsif(prob % 25 == 0)
		epiX = rand(58 - 14) + 14
		epiY = rand(17 - 3) + 
		sz = rand(6-3) + 3
		earthquake1 = Earthquake.new(sz, epiX, epiY, @currentTime)
		earthquake1.spawnTsunamis
			earthquake1.getTsunamisList.each do |tsunami|
				addObject(tsunami)
			end
		addObject(earthquake1)
		end
	end

	def handle_kingdoms(islands)
		@islands.each do |island|
			if(@moon == 1)
				island.monthlyPay
			end
			if(@moon == 1 && @month == "jan")
				island.yearlyPopExplosion
			end
			island.think(@islands)
		end
		@islands.each do |island|
			island.getActiveTradeBoats.each do |boat|
				if(@objects.include?(boat) == false)
					addObject(boat)
				end
			end
			island.getActiveWarBoats.each do |boat|
				if(@objects.include?(boat) == false)
					addObject(boat)
				end
			end
		end
	end

	def random_typhoon_generator
		r = rand(50)
		#Normal Typhoon
		if(r%25 == 0)
		sz = rand(3)
		sX = rand(40-12) + 12
		sY = rand(12-1) + 1
		dX = rand(10-3) + 3
		dY = rand(2-1) + 1
		typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
		addObject(typhoon1)
		end
		#Strong Typhoon
		if(r%49 == 0)
		sz = 3
		sX = rand(46-12) + 12
		sY = rand(12-1) + 1
		dX = rand(11-3) + 3
		dY = rand(2-1) + 1
		typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
		addObject(typhoon1)
		end
	end
	
	def make_diplomacy_window
	  winfo = Window.new(4, 64, 26, (cols-100)/2)
	  winfo.box(?|, ?-)
	  winfo.setpos(2, 3)
	  winfo.refresh
	end
	
	def make_kingdom_info_window(islands)
	  kinfo = Window.new(25, 30, (((lines-25)/2)-2), 64+((cols-100)/2))
	  kinfo.box(?|, ?-)
			x = 1
			y = 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(6).getName.slice(0,1).capitalize+islands.at(6).getName.slice(1..-1)}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("$#{islands.at(6).getCurrentWealth}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(6).getEnemies}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(6).getTradePartners}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(7).getName.slice(0,1).capitalize+islands.at(7).getName.slice(1..-1)}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("$#{islands.at(7).getCurrentWealth}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(7).getEnemies}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(7).getTradePartners}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(13).getName.slice(0,1).capitalize+islands.at(13).getName.slice(1..-1)}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("$#{islands.at(13).getCurrentWealth}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(13).getEnemies}")
			y += 1
			kinfo.setpos(y, x)
			kinfo.addstr("#{islands.at(13).getTradePartners}")
#		@islands.each do |island|
#		
#	  		kinfo.setpos(y, x)
#			kinfo.addstr("#{island.getName.slice(0,1).capitalize+island.getName.slice(1..-1)} -	$#{island.getCurrentWealth}")
#			y+=1
#			kinfo.setpos(y, x)
#			kinfo.addstr("-->Pop:#{island.getPopulation}	ShipSkill:#{island.getShipGuildSkill}")
#			y+=1
#		end	
		
	  kinfo.refresh
	end
end	


# Begin script of Pacifica (c) simulation and game
init_screen
noecho
begin
crmode
pacifica = Pacifica.new
pacifica.addIslands
	# adding one enemy to each island's list
	pacifica.getIslands.each do |island|
		randomIslandId = rand(13) + 1
		enemy = pacifica.getIslands.at(randomIslandId).getName
		island.addEnemy(enemy)
	end
pacifica.make_diplomacy_window

while TRUE
	objTemp = Array.new
	# size check - tsunamis and storms of size 0 and boats w/ too few crew get removed from list
	pacifica.clearHazards
	pacifica.getObjects.each do |object|
		if(object.class.name == "Earthquake")
			if((pacifica.getCurrentTime - object.getSpawnTime) < 4)
				objTemp.push(object)
				pacifica.addEpicenterX(object.getLocationX)
				pacifica.addEpicenterY(object.getLocationY)
			end		
		end
		if(object.class.name == "Tsunami" || object.class.name == "Typhoon")
			if(object.getSize > 0)
				objTemp.push(object)
				if(object.class.name == "Tsunami")
					if(object.getSize == 1)
					pacifica.addHazardX(object.getLocationX-1, object.getLocationX, object.getLocationX+1, nil, nil, nil, nil, nil, nil, nil, nil)
					pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
					elsif(object.getSize == 2)
					pacifica.addHazardX(object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, nil, nil, nil, nil, nil, nil)
					pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
					elsif(object.getSize == 3)
					pacifica.addHazardX(object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, nil, nil, nil, nil)
					pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
					elsif(object.getSize == 4)
					pacifica.addHazardX(object.getLocationX-4, object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2,object.getLocationX+3, object.getLocationX+4,nil,nil)
					pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
					elsif(object.getSize == 5)
					pacifica.addHazardX(object.getLocationX-5, object.getLocationX-4, object.getLocationX-3, object.getLocationX-2, object.getLocationX-1,object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, object.getLocationX+4, object.getLocationX+5)
					pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
					end
				elsif(object.class.name == "Typhoon")
					if(object.getSize == 1)
					pacifica.addHazardX(object.getLocationX-1, object.getLocationX, object.getLocationX+1, nil, nil, nil, nil, nil, nil, nil, nil)
					pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
					elsif(object.getSize == 2)
					pacifica.addHazardX(object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, nil, nil, nil, nil, nil, nil)
					pacifica.addHazardY(object.getLocationY-2, object.getLocationY-1, object.getLocationY, object.getLocationY+1, object.getLocationY+2, nil, nil, nil, nil)
					elsif(object.getSize == 3)
					pacifica.addHazardX(object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, nil, nil, nil, nil)
					pacifica.addHazardY(object.getLocationY-3, object.getLocationY-2, object.getLocationY-1, object.getLocationY, object.getLocationY+1, object.getLocationY+2, object.getLocationY+3, nil, nil)
					end
				end		
			end		
		end
		if(object.class.name == "Boat")
			if(object.getType == "war")
				if(object.getCurrentCrew > 2)
					objTemp.push(object)
				end	
			end	
			if(object.getType == "trade")
				if(object.getCurrentCrew > 1)
					objTemp.push(object)
				end	
			end	
		end
		
	end
		
	pacifica.setObjects(objTemp)
	#add all islands to islands
	#add all earthquakes to objects, then all waves, boats, then typhoons
	case pacifica.getCurrentTime
		when 0..9
		pacifica.setMonth("jan")
		when 10..19
		pacifica.setMonth("feb")
		when 20..29
		pacifica.setMonth("mar")
		when 30..39
		pacifica.setMonth("apr")
		when 40..49
		pacifica.setMonth("may")
		when 50..59
		pacifica.setMonth("jun")
		when 60..69
		pacifica.setMonth("jul")
		when 70..79
		pacifica.setMonth("aug")
		when 80..89
		pacifica.setMonth("sep")
		when 90..99
		pacifica.setMonth("oct")
		when 100..109
		pacifica.setMonth("nov")
		when 110..119
		pacifica.setMonth("dec")	
	end
		pacifica.make_game_window(pacifica.getIslands, pacifica.getObjects, pacifica.getMonth, pacifica.getYear, pacifica.getCurrentTime)
		pacifica.make_kingdom_info_window(pacifica.getIslands)
		sleep(0.05)
	if(pacifica.getCurrentTime < 120)
		pacifica.setCurrentTime(pacifica.getCurrentTime+1)
	elsif(pacifica.getCurrentTime == 120)
		pacifica.setCurrentTime(0)
		pacifica.setYear((pacifica.getYear+1))
	end
end
ensure
  close_screen
end


