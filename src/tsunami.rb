#!/usr/local/bin/ruby


require "curses"
include Curses

=begin
This class defines the tsunami object. 

A wave sweeps either up or down until it fades out.

Sizes: widths: image
1: 3:      ~~~
2: 5:     ~~~~~
3: 7:    ~~~~~~~
4: 9:   ~~~~~~~~~
5: 11: ~~~~~~~~~~~


waves are spawned by earthquakes and typhoons.

Attributes:
size-> int, determines width and power of tsunami
locationX -> int, current X position on grid
locationY -> int, current Y position on grid
direction -> string, up or down direction of movement
Size diminishes by 1 every step

Hollaaa
=end


class Tsunami
	
	def initialize(size, locationX, locationY, direction, spawnTime)
		@size = size
		@locationX = locationX
		@locationY = locationY
		@direction = direction
		@spawnTime = spawnTime
	end

	def getSpawnTime
		@spawnTime
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
		if (@direction == "up")
			@locationY -=1
		elsif(@direction == "down")
			@locationY +=1
		end
		@size -= 1
		r = rand(10)
		if(r < 4)
			@size += 1
		end
		if(@locationY == 0 || @locationY == 20)
			@size = 0
		end
	end

end





