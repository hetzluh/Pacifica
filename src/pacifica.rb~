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
		@year = 500
		@month = "jan"
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

	def addIslands
=begin
		Reminder: (kingdomId, name, size, startWealth, currentWealth, power, population
					popcap, shipGuildSkill, locationX, locationY)
=end
		kiribati = Island.new(1, "kiribati", 1, 50, 50, 1.2, 15, 70, 1, 4, 6)
		kwajaleins = Island.new(2, "kwajaleins", 1, 50, 50, 1.2, 15, 70, 1, 3, 3)
		hawaii = Island.new(3, "hawaii", 2, 60, 60, 1.6, 20, 85, 2, 28, 2)
		samoa = Island.new(4, "samoa", 0, 40, 40, 1.4, 15, 70, 1, 17, 11)
		tokelau = Island.new(5, "tokelau", 0, 30, 30, 1.3, 10, 60, 2, 15, 9)
		vanuatu = Island.new(6, "vanuatu", 1, 35, 35, 1.4, 15, 70, 1, 2, 12)
		tahiti = Island.new(7, "tahiti", 0, 40, 40, 1.3, 25, 60, 3 ,34, 10)
		takutea = Island.new(8, "takutea", 0, 40, 40, 1.3, 25, 60, 3, 26, 11)
		tuvalu = Island.new(9, "tuvalu", 0, 35, 35, 1.3, 10, 60, 2, 8, 8)
		fiji = Island.new(10, "fiji", 1, 40, 40, 1.3, 15, 70, 1,  10, 13)
		tonga = Island.new(11, "tonga", 0, 35, 35, 1.3, 10, 60, 2, 15, 14)
		tuamotus = Island.new(12, "tuamotus", 1, 40, 40, 1.3, 15, 70, 3, 43, 13)
		rapanui = Island.new(13, "rapa nui", 1, 55, 55, 1.5, 15, 75, 4, 55, 15)
		aotearoa = Island.new(14, "aotearoa", 2, 55, 55, 1.6, 20, 85, 3, 4, 17)

		@islands.push(kiribati, kwajaleins, hawaii, samoa, tokelau,
						 tuvalu, vanuatu, fiji, tonga, tahiti,
						 takutea, aotearoa, tuamotus, rapanui)
	end

	def make_game_window(islands, objects, month, year, time)
	  win = Window.new(20, 60, ((lines-25)/2)-2, (cols-100)/2)
	  win.box(?|, ?-)
		moon = (time+1)%10
		if moon == 0
			moon = 10
		end
	  win.addstr("Moon: #{moon}, Month: #{month}, Year: #{year}")
	
		@islands.each do |island|
			y = island.getLocationY
			x = island.getLocationX
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
			win.setpos(y, x)
			if(object.class.name == "Earthquake")
			win.addstr("E")
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
		r = rand(5)
		epiX = rand(57 - 3) +3
		epiY = rand(18 - 1) +1
		sz = rand(5)
		if(r%5 == 0)
		earthquake1 = Earthquake.new(sz, epiX, epiY, @currentTime)
		earthquake1.spawnTsunamis
			earthquake1.getTsunamisList.each do |tsunami|
				addObject(tsunami)
			end
		addObject(earthquake1)
		end
	end
	
	def random_typhoon_generator
		r = rand(5)
		sz = rand(3)
		sX = rand(46-12) + 12
		sY = rand(12-1) + 1
		dX = rand(8-4) + 4
		dY = rand(3-1) + 1
		if(r%5 == 0)
		typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
		addObject(typhoon1)
		end
	end
	
	def make_diplomacy_window
	  winfo = Window.new(8, 60, 22, (cols-100)/2)
	  winfo.box(?|, ?-)
	  winfo.setpos(2, 3)
	  winfo.refresh
	end
	
	def make_kingdom_info_window(islands)
	  kinfo = Window.new(29, 36, (((lines-25)/2)-2), 64+((cols-100)/2))
	  kinfo.box(?|, ?-)
			x = 1
			y = 1
		@islands.each do |island|
		
	  		kinfo.setpos(y, x)
			kinfo.addstr("#{island.getName.slice(0,1).capitalize+island.getName.slice(1..-1)} -	$#{island.getCurrentWealth}")
			y+=1
			kinfo.setpos(y, x)
			kinfo.addstr("-->Pop:#{island.getPopulation}	ShipSkill:#{island.getShipGuildSkill}")
			y+=1
		end	
		
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
pacifica.make_kingdom_info_window(pacifica.getIslands)
pacifica.make_diplomacy_window

while TRUE
	objTemp = Array.new
	# size check - tsunamis and storms of size 0 and boats w/ too few crew get removed from list
	pacifica.getObjects.each do |object|
		if(object.class.name == "Earthquake")
			if((pacifica.getCurrentTime - object.getSpawnTime) < 4)
				objTemp.push(object)
			end		
		end
		if(object.class.name == "Tsunami" || object.class.name == "Typhoon")
			if(object.getSize > 0)
				objTemp.push(object)
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
	sleep(0.3)
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


