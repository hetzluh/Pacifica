#!/usr/local/bin/ruby


require 'island.rb'
require 'boat.rb'

require "curses"
include Curses

=begin
This class is the simulation's main script
lines = 31, cols = 113
top left = (1, 6)
=end

def make_game_window(islands, boats)
  win = Window.new(20, 60, ((lines-25)/2)-2, (cols-100)/2)
  win.box(?|, ?-)


	islands.each do |island|
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
			win.addstr("'")
			win.setpos(y+1, x-1)
			win.addstr("ooo")
		end
	end

=begin
	boats.each do |boat|
     win.setpos(p1, p2)
 	 win.addstr(boat.spawn)
	end
=end
loop do


  win.refresh

end
 win.close
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
	islands.each do |island|
	
  		kinfo.setpos(y, x)
		kinfo.addstr("#{island.getName.slice(0,1).capitalize+island.getName.slice(1..-1)} -	$#{island.getCurrentWealth}")
		y+=1
		kinfo.setpos(y, x)
		kinfo.addstr("-->Pop:#{island.getCurrentPopulation}	ShipSkill:#{island.getShipGuildSkill}")
		y+=1
	end	
	
  kinfo.refresh
end

init_screen
noecho
begin
    crmode
	islands = Array.new
	boats = Array.new
	kiribati = Island.new(0, "kiribati", 0, 1000, 1.8, 
					9000, 9000, 
					3, 2, 4, 6)
	kwajaleins = Island.new(0, "kwajaleins", 1000, 1000, 1.8, 
					9000, 9000, 
					3, 2, 3, 3)
	hawaii = Island.new(0, "hawaii", 1000, 1000, 1.8, 
					9000, 9000, 
					3, 2, 28, 2)
	samoa = Island.new(0, "samoa", 0, 0, 1.0, 
					0, 0, 
					0, 0, 17, 11)
	tokelau = Island.new(0, "tokelau", 0, 0, 1.0, 
					0, 0, 
					0, 0, 15, 9)
	tuvalu = Island.new(0, "tuvalu", 0, 0, 1.0, 
					0, 0, 
					0, 0, 8, 8)
	vanuatu = Island.new(0, "vanuatu", 0, 0, 1.0, 
					0, 0, 
					0, 0, 2, 12)

	fiji = Island.new(0, "fiji", 0, 0, 1.0, 
					0, 0, 
					0, 0, 10, 13)

	tonga = Island.new(0, "tonga", 0, 0, 1.0, 
					0, 0, 
					0, 0, 15, 14)
	tahiti = Island.new(0, "tahiti", 0, 0, 1.0, 
					0, 0, 
					0, 0, 34, 10)
	takutea = Island.new(0, "takutea", 0, 0, 1.0, 
					0, 0, 
					0, 0, 26, 11)
	aotearoa = Island.new(0, "aotearoa", 0, 0, 1.0, 
					0, 0, 
					0, 0, 4, 17)
	tuamotus = Island.new(0, "tuamotus", 0, 0, 1.0, 
					0, 0, 
					0, 0, 43, 13)
	rapanui = Island.new(0, "rapa nui", 0, 0, 1.0, 
					0, 0, 
					0, 0, 55, 15)


	islands.push(kiribati, kwajaleins, hawaii, samoa, tokelau,
						 tuvalu, vanuatu, fiji, tonga, tahiti,
						 takutea, aotearoa, tuamotus, rapanui)
	make_kingdom_info_window(islands)
	make_diplomacy_window
	make_game_window(islands, boats)

ensure
  close_screen
end


