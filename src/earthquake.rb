#!/usr/local/bin/ruby


require './tsunami.rb'

=begin
This class defines the earthquake object. 

Size = wave spawn size
Epicenter symbol = E

earthquakes are spawned at random, less frequently toward the center of the map

Attributes:
size-> int, 1-5, determines power of Earthquake
locationX -> int, epicenter X position on grid
locationY -> int, epicenter Y position on grid
tsunamisList -> array, list of tsunami objects 
Epicenter visible for 3 steps

Hollaaa
=end


class Earthquake

  def initialize(size, locationX, locationY, spawnTime)
    @size = size
    @locationX = locationX
    @locationY = locationY
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

  def spawnTsunamis
    wave1 = Tsunami.new(@size, @locationX, @locationY-1, "up", @spawnTime)
    wave2 = Tsunami.new(@size, @locationX, @locationY+1, "down", @spawnTime)
    @tsunamisList.push(wave1, wave2)
  end
end
