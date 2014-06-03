#!/usr/local/bin/ruby


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
size -> int, 0-2, size modifier used for various purposes
shipGuildSkill -> int, 1-5, determines boat effectiveness

Hollaaa
=end


class Kingdom
	def initialize(kingdomId, name, startWealth, currentWealth, power, 
					startPopulation, currentPopulation, 
					shipGuildSkill, size)
		#initializing all kingdom attributes
		@kingdomId = kingdomId
		@name = name
		@startWealth = startWealth
		@currentWealth = currentWealth 
		@power = power
		@startPopulation = startPopulation
		@currentPopulation = currentPopulation

	end






#END kingdom.rb
