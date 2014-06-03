#!/usr/local/bin/ruby


require "curses"
include Curses

=begin
This class defines the tsunami object. 

A wave sweeps either up or down until it fades out.

Sizes: widths
1:   -
	(@)
     -
2: 	
	  ^
	((@))
	  v
3: 	
	   ^	
	  ---
	(((@)))
	  ---
	   v
typhoons are spawned near the northern center of the map and move in a north or northwest sweep.

Attributes:
size-> int, determines width and power of tsunami
locationX -> int, current X position on grid
locationY -> int, current Y position on grid
destinationX -> int, the final X destination of the storm
destinationY -> int, the final Y destination of the storm
Size diminishes by 1 every step

Hollaaa
=end


class Typhoon
	
	def initialize(size, locationX, locationY, destinationX, destinationY, spawnTime)
		@size = size
		@locationX = locationX
		@locationY = locationY
		@destinationX = destinationX
		@destinationY = destinationY
		@tsunamisList = Array.new
		@spawnTime = spawnTime
	end

	def getSpawnTime
		@spawnTime
	end	

	def getTsunamisList
		@tsunamisList
	end

	def getSize
		@size
	end
	
	def getLocationX
		@locationX
	end
	
	def getLocationY
		@locationY
	end
	
	def move
		dx = @locationX - @destinationX
		dy = @locationY - @destinationY
		if(dx > 0 || dy > 0)
		newRand = rand(10)
			if(newRand % 2 == 0)
			@locationX -= 1 
			dx -= 1
			elsif(newRand % 2 ==1)
			@locationY -= 1
			dy -= 1
			end		
		end	
		if(dx == 1 || dy == 1)
			@size = 0
		end
	end
	
end
