#!/usr/local/bin/ruby


require './boat.rb'


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
    if (@name == "vanuatu" || @name == "fiji" || @name == "tuvalu" || @name == "tokelau" || @name == "samoa" || @name == "tonga")
      @group = 1
    elsif (@name == "hawaii" || @name == "aotearoa")
      @group = 2
    elsif (@name == "tuamotus" || @name == "rapa nui")
      @group = 3
    elsif (@name == "tahiti" || @name == "takutea")
      @group = 4
    elsif (@name =="kwajaleins" || @name == "kiribati")
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
    @goal = "TRADING"
    @devMode = devMode
    @year = 500
    @month = "jan"
    @moon = 1
    @defeated = false

    if (@group == 1)
      if @devMode == 1
        @team = "palm"
      else
        r = rand(10 + 1) - 1
        if (r < 5)
          @team = "aqua"
        elsif (r > 4 && r < 8)
          @team = "palm"
        elsif (r == 8 || r == 9)
          @team = "pearl"
        elsif (r == 10)
          @team = "obsidian"
        end
      end
    elsif (@group == 2)
      if @devMode == 1
        @team = "obsidian"
      else
        r = rand(10 + 1) - 1
        if (r < 4)
          @team = "obsidian"
        elsif (r == 4)
          @team = "palm"
        elsif (r == 5 || r == 6)
          @team = "pearl"
        elsif (r > 6)
          @team = "aqua"
        end
      end
    elsif (@group == 3)
      if @devMode == 1
        @team = "neutral"
      else

        r = rand(10 + 1) - 1
        if (r < 5)
          @team = "aqua"
        elsif (r == 5)
          @team = "palm"
        elsif (r == 6 || r == 7)
          @team = "obsidian"
        elsif (r > 7)
          @team = "pearl"
        end
      end
    elsif (@group == 4)
      if @devMode == 1
        @team = "pearl"
      else

        r = rand(10 + 1) - 1
        if (r < 5)
          @team = "aqua"
        elsif (r == 5 || r == 6)
          @team = "pearl"
        elsif (r == 7 || r == 8)
          @team = "obsidian"
        elsif (r == 9 || r == 10)
          @team = "palm"
        end
      end
    elsif (@group == 5)
      if @devMode == 1
        @team = "aqua"
      else
        r = rand(10 + 1) - 1
        if (r < 6)
          @team = "aqua"
        elsif (r == 6)
          @team = "obsidian"
        elsif (r == 7 || r == 8)
          @team = "palm"
        elsif (r == 9 || r == 10)
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

  def getDefeated
    @defeated
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
    payout = (@power*2)+@size
    @currentWealth += payout.ceil
  end

  def yearlyPopExplosion
    r = rand(2)
    if (r == 1)
      @population += ((5 * @power) + @size).ceil
    else
      @population += ((2 * @power) + @size).ceil
    end
  end

  def getPlayerIsland
    @playerIsland
  end

  def setPlayerIsland(setBool)
    @playerIsland = setBool
  end

  def updateGoal
    if (@population > @popcap/4 && @currentWealth > 10)
      if (@currentWealth < 20)
        @goal = "TRADING"
      elsif (@enemies.size > 0 && @currentWealth >= 30)
        @goal = "RAIDING"
      elsif (@enemies.size == 0 && @currentWealth > 30)
        findRandomEnemy(@islandsList)
        @goal = "RAIDING"
      end
    end
  end

  def think(islands, playerOption, playerState)
    #save copy of islands list
    @islandsList = islands
    #purge non-unique array entries
    @allies.uniq!
    @enemies.uniq!
    # purging enemy allies every 20% of the time and deleting defeated enemies and allies
    i = rand(5)
    if (i == 3)
      @enemies.each do |enemy|
        if (enemy.getDefeated == true)
          @enemies.delete(enemy)
        end
        enemyAllies = enemy.getAllies
        newAllies = @allies - enemyAllies
        @allies = newAllies
      end
      @allies.each do |ally|
        if (ally.getDefeated == true)
          @allies.delete(ally)
        end
      end
    end

    #purge dead boats
    purgeBoats

    # Case for AI
    if (@playerIsland == false)
      #sets goal (might need to move into the if clause)
       updateGoal
      r = rand(20)
      if (r > 15 && @population > @popcap/4 && @currentWealth > 10)
        r = rand(@allies.size)
        if (@allies.size > 0 && @goal=="TRADING")
          if (@allies.at(r).getDefeated == false && (getActiveTradeBoats.size + getActiveWarBoats.size) < 2)
            makeTradeBoat(@allies.at(r).getName)
          end
          r2 = rand(10)
          if (r2 == 1 && @allies.size < 4)
            newTradePartner(islands)
          end
        elsif (@enemies.size > 0 && @goal=="RAIDING")
          if (@currentWealth >= 30)
            if (@enemies.size > 0)
              sendWarToRandomEnemy
            end
          end
        elsif (@allies.size == 0 && r < 10)
          newTradePartner(islands)
        elsif (@enemies.size == 0 && r < 5)
          findRandomEnemy(islands)
        end
      elsif (r < 2)
        babiesBorn
      end
      # Case for actual player
    elsif (@playerIsland == true)
      if (@playerState == "default")
      elsif (@playerState == "sendingTrade")
        if (playerOption == "-")
          makeTradeBoat("tonga")
        elsif (playerOption == "=")
          makeTradeBoat("tuamotus")
        elsif (playerOption == "[")
          makeTradeBoat("rapa nui")
        elsif (playerOption == "]")
          makeTradeBoat("aotearoa")
        elsif (playerOption =~ /[0-9]/)
          makeTradeBoat(islands.at(playerOption.to_i).getName)
          setPlayerState("default")
        end
      elsif (@playerState == "sendingWar")
        if (playerOption == "-")
          makeWarBoat("tonga")
        elsif (playerOption == "=")
          makeWarBoat("tuamotus")
        elsif (playerOption == "[")
          makeWarBoat("rapa nui")
        elsif (playerOption == "]")
          makeWarBoat("aotearoa")
        elsif (playerOption =~ /[0-9]/)
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

  def findRandomEnemy(islands)
    r = rand(islands.size)
    if (islands.at(r).getName != @name && @allies.include?(islands.at(r).getName) == false && @enemies.include?(islands.at(r).getName) == false)
      addEnemy(islands.at(r))
    end
  end

  def newTradePartner(islands)
    randomIslandId = rand(13) + 1
    newPartner = islands.at(randomIslandId)
    if (@enemies.include?(newPartner.getName) == false)
      addAlly(newPartner)
    end
  end

  def findRandomTradePartner
    r = rand(@allies.length - 1) + 1
    @allies.at(r)
  end

  def babiesBorn
    r = rand(2)
    @population += r
    if (@population > @popcap)
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
    @currentWealth = @currentWealth + plusAmt
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
    @activeTradeBoats
  end

  def purgeBoats
    deadWarBoats = Array.new
    deadTradeBoats = Array.new
    #first purge war boats
    @activeWarBoats.each do |boat|
      if (boat.getCurrentCrew == 0)
        deadWarBoats.push(boat)
      end
    end
    @activeWarBoats.compact

    #purge trade boats
    @activeTradeBoats.each do |boat|
      if (boat.getCurrentCrew == 0)
        deadTradeBoats.push(boat)
      end
    end

    newTradeBoats = @activeTradeBoats - deadTradeBoats
    newWarBoats = @activeWarBoats - deadWarBoats
    @activeTradeBoats = newTradeBoats
    @activeWarBoats = newWarBoats
  end

  def getActiveWarBoats
    @activeWarBoats
  end

  def makeWarBoat(destinationIslandName)
    if (destinationIslandName != @name && @currentWealth > 14 && @population > 9 && @defeated == false)
      @currentWealth -= 15
      @population -= 10
      if (destinationIslandName == "kiribati")
        destinationX = 7
        destinationY = 8
      elsif (destinationIslandName == "kwajaleins")
        destinationX = 4
        destinationY = 4
      elsif (destinationIslandName == "hawaii")
        destinationX = 32
        destinationY = 4
      elsif (destinationIslandName == "samoa")
        destinationX = 21
        destinationY = 15
      elsif (destinationIslandName == "tokelau")
        destinationX = 15
        destinationY = 11
      elsif (destinationIslandName == "vanuatu")
        destinationX = 4
        destinationY = 15
      elsif (destinationIslandName == "tahiti")
        destinationX = 40
        destinationY = 15
      elsif (destinationIslandName == "takutea")
        destinationX = 33
        destinationY = 14
      elsif (destinationIslandName == "tuvalu")
        destinationX = 10
        destinationY = 9
      elsif (destinationIslandName == "fiji")
        destinationX = 11
        destinationY = 17
      elsif (destinationIslandName == "tonga")
        destinationX = 18
        destinationY = 18
      elsif (destinationIslandName == "tuamotus")
        destinationX = 50
        destinationY = 16
      elsif (destinationIslandName == "rapa nui")
        destinationX = 58
        destinationY = 18
      elsif (destinationIslandName == "aotearoa")
        destinationX = 8
        destinationY = 20
      else
        destinationX = 59
        destinationY = 1
      end

      if (getShipGuildSkill < 4)
        warBoat = Boat.new(@kingdomId, @name, destinationIslandName, 10, @locationX, @locationY+1, destinationX, destinationY, "war", 0, @shipGuildSkill)
      else
        warBoat = Boat.new(@kingdomId, @name, destinationIslandName, 15, @locationX, @locationY+1, destinationX, destinationY, "war", 0, @shipGuildSkill)
      end
      @activeWarBoats.push(warBoat)
      if (@enemies.include?(destinationIslandName) == false)
        @islandsList.each do |island|
          if (island.getName == destinationIslandName)
            addEnemy(island)
          end
        end
      end
      @boatsSent += 1
    end
  end

  def makeTradeBoat(destinationIslandName)
    if (destinationIslandName != @name && @currentWealth > 3 && @population > 4 && @defeated == false)
      @currentWealth -= 3
      @population -= 5
      if (destinationIslandName == "kiribati")
        destinationX = 7
        destinationY = 8
      elsif (destinationIslandName == "kwajaleins")
        destinationX = 4
        destinationY = 4
      elsif (destinationIslandName == "hawaii")
        destinationX = 32
        destinationY = 4
      elsif (destinationIslandName == "samoa")
        destinationX = 21
        destinationY = 15
      elsif (destinationIslandName == "tokelau")
        destinationX = 15
        destinationY = 11
      elsif (destinationIslandName == "vanuatu")
        destinationX = 4
        destinationY = 15
      elsif (destinationIslandName == "tahiti")
        destinationX = 40
        destinationY = 15
      elsif (destinationIslandName == "takutea")
        destinationX = 33
        destinationY = 14
      elsif (destinationIslandName == "tuvalu")
        destinationX = 10
        destinationY = 9
      elsif (destinationIslandName == "fiji")
        destinationX = 11
        destinationY = 17
      elsif (destinationIslandName == "tonga")
        destinationX = 18
        destinationY = 18
      elsif (destinationIslandName == "tuamotus")
        destinationX = 50
        destinationY = 16
      elsif (destinationIslandName == "rapa nui")
        destinationX = 58
        destinationY = 18
      elsif (destinationIslandName == "aotearoa")
        destinationX = 8
        destinationY = 20
      else
        destinationX = 59
        destinationY = 1
      end

      if (getShipGuildSkill < 3)
        tradeBoat = Boat.new(@kingdomId, @name, destinationIslandName, 5, @locationX, @locationY+1, destinationX, destinationY, "trade", 0, @shipGuildSkill)
      else
        tradeBoat = Boat.new(@kingdomId, @name, destinationIslandName, 10, @locationX, @locationY+1, destinationX, destinationY, "trade", 0, @shipGuildSkill)
      end

      @activeTradeBoats.push(tradeBoat)
      @boatsSent += 1

      if (@boatsSent % 10 == 0 && @shipGuildSkill < 5)
        @shipGuildSkill += 1
      end
    end
  end

  def earthquake
    @population = -1
  end

  def attacked(numberAttacking, kingdomAttacking)
    @population -= 10
    if (@population <= 0)
      @population = 0
      @defeated = true
    end
    @islandsList.each do |island|
      if (island.getName == kingdomAttacking && @enemies.include?(kingdomAttacking) == false)
        @enemies.push(island)
      end
    end
    @allies.each do |ally|
      if ally.getName == kingdomAttacking
        @allies.delete(ally)
      end
    end
  end

  def addEnemy(island)
    @enemies.push(island)
  end

  def addAlly(island)
      @allies.push(island)
  end

  def traded(numberCrew, kingdomTrading)
    @population += numberCrew
    @currentWealth += 5
    if (@enemies.include?(kingdomTrading) == false)
      @islandsList.each do |island|
        if (island.getName == kingdomTrading)
          addAlly(island)
        end
      end
    end
  end

  def setPopulation(plusAmt)
    if (@population + plusAmt <= @popcap)
      @population = @population + plusAmt
    end
  end

  def setPower(plusAmt)
    @power = ((@power + plusAmt)*10).ceil/10.0
  end

  def setShipSkill(plusAmt)
    @shipGuildSkill = @shipGuildSkill + plusAmt
  end

  def sendTradeToRandomAlly
    if (@allies.size > 0)
      r = rand(@allies.size)
      # second chance..programmer is lazy as fuck
      if (@allies.at(r).getDefeated == true)
        r = rand(@allies.size)
      end
      if (@allies.at(r).getDefeated == false && (getActiveTradeBoats.size + getActiveWarBoats.size) < 2)
        makeTradeBoat(@allies.at(r).getName)
      end
    end

  end

  def sendWarToRandomEnemy
    if (@enemies.size > 0)
      r = rand(@enemies.size)
      # second chance..programmer is lazy as fuck
      if (@enemies.at(r).getDefeated == true)
        r = rand(@enemies.size)
      end
      if (@enemies.at(r).getDefeated == false && (getActiveTradeBoats.size + getActiveWarBoats.size) < 2)
        makeWarBoat(@enemies.at(r).getName)
      end
    end

  end
end
#END island.rb
