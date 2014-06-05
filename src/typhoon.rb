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
		@size = 1
		@locationX = locationX
		@locationY = locationY
		@destinationX = destinationX
		@destinationY = destinationY
		@tsunamisList = Array.new
		@spawnTime = spawnTime
		if(size == 1 || size == 2)
			@bigOne = false
		elsif(size == 3)
			@bigOne = true
		end
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
	
	def growOrShrink

		#grow
		if(@bigOne == false && @size == 1)
			r = rand(10)
			if(r > 3)
				growthBool = true
			else
				growthBool = false
			end
			if(growthBool == true)
				@size += 1
			end
		elsif(@bigOne == true && @size < 3)
			r = rand(10)
			if(r > 2)
				growthBool = true
			else
				growthBool = false
			end
			if(@size == 1 && growthBool == true)
				@size += 1
			end
			if(@size == 2 && growthBool == true)
				@size += 1
			end
		#shrink
		elsif(@bigOne == false && @size == 2)
		r = rand(10)
		if(r > 7)
		growthBool = true
		else
		growthBool = false
		end
			if(growthBool == true)
				@size -= 1
			end
		elsif(@bigOne == true && @size == 3)
		r = rand(10)
		if(r > 8)
		growthBool = true
		else
		growthBool = false
		end
			if(@size == 3 && growthBool == true)
				@size -= 1
			end
			if(@size == 2 && growthBool == true)
				@size -= 1
			end
		end
	end

	def move
		dx = @locationX - @destinationX
		dy = @locationY - @destinationY
		newRand = rand(10)
		otherRand = rand(100)
		if(otherRand % 3 == 0)
			if(dx > 0 || dy > 0)
				if(newRand % 2 == 0)
					@locationX -= 1 
					dx -= 1
				elsif(newRand % 2 ==1)
					@locationY -= 1
					dy -= 1
				end		
			end	
		end	
		growOrShrink
		if(dx <= 3 || dy <= 3)
			if(newRand % 2 == 0)
			@size -= 1 
			end
		end
		if(dx == 0 || dy == 0)
		@size = 0 
		end
	end
	
end
