#!/usr/local/bin/ruby


require './island.rb'
require './boat.rb'
require './earthquake.rb'
require './tsunami.rb'
require './typhoon.rb'
require './event.rb'

require "curses"
include Curses

=begin
This class is the simulation's main script
lines = 31, cols = 113
top left = (1, 6)
=end

class Pacifica
  def initialize()
    @devMode = 0 #Set this to 1 for static teams for development/testing
    @currentTime = -1
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
    @palmAlliance = Array.new
    @obsidianAlliance = Array.new
    @pearlAlliance = Array.new
    @aquaAlliance = Array.new
    @palmAllianceDefeated = false
    @obsidianAllianceDefeated = false
    @pearlAllianceDefeated = false
    @aquaAllianceDefeated = false
    @playerIsland = Island.new(3, "hawaii", 2, 60, 60, 1.6, 85, 85, 2, 32, 3, false, @devMode)
    @diplomacyState = "main"
    @mapMode = false
    @infoState = "kingdoms" #states: kingdoms, events, allies & enemies, help
    @playerOption = nil
    @first_make_game = true
    @alliesText = "OFF"
    @enemiesText = "OFF"
    @alliesBlue = false
    @enemiesRed = false
    @eventsMaster = Array.new
    @islandSelectedAlliesAndEnemies
    @islandSelectedAlliesAndEnemiesIndex = 0
    @selectionMade = false
    @playerPrayersThisYear = 0
    @getNumberOfDefeatedAlliances = 0
  end

  def getAlliances
    alliances = Array.new
    alliances.push(@palmAlliance)
    alliances.push(@aquaAlliance)
    alliances.push(@obsidianAlliance)
    alliances.push(@pearlAlliance)
     return alliances
  end

  def getDefeatedAlliances
    alliances = getAlliances
    defeatedAlliances = Array.new
    if(@palmAllianceDefeated == true)
      alliances.push(@palmAlliance)
    end
    if(@obsidianAllianceDefeated == true)
      alliances.push(@obsidianAlliance)
    end
    if(@pearlAllianceDefeated == true)
      alliances.push(@pearlAlliance)
    end
    if(@aquaAllianceDefeated == true)
      alliances.push(@aquaAlliance)
    end
  end

  def getNumberOfDefeatedAlliances
    defeatedAlliances = 0
    defeatedAllies = 0
    @palmAlliance.each do |island|
      if (island.getDefeated == true)
        defeatedAllies += 1
      end
      if defeatedAllies == @obsidianAlliance.size
        defeatedAlliances += 1
        @palmAllianceDefeated = true
      end
    end
    @obsidianAlliance.each do |island|
      if (island.getDefeated == true)
        defeatedAllies += 1
      end
      if defeatedAllies == @obsidianAlliance.size
        defeatedAlliances += 1
        @palmAllianceDefeated = true
      end
    end
    @pearlAlliance.each do |island|
      if (island.getDefeated == true)
        defeatedAllies += 1
      end
      if defeatedAllies == @obsidianAlliance.size
        defeatedAlliances += 1
        @palmAllianceDefeated = true
      end
    end
    @aquaAlliance.each do |island|
      if (island.getDefeated == true)
        defeatedAllies += 1
      end
      if defeatedAllies == @obsidianAlliance.size
        defeatedAlliances += 1
        @palmAllianceDefeated = true
      end
    end
    return defeatedAlliances
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

  def getPlayerPrayersThisYear
    @playerPrayersThisYear
  end

  def setPlayerPrayersThisYear(setTo)
    @playerPrayersThisYear = setTo
  end

  def getIslands
    @islands
  end

  def setObjects(objArr)
    @objects = objArr
  end

  def getEvents
    @eventsMaster
  end

  def setEvents(toSet)
    @eventsMaster = toSet
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
					popcap, shipGuildSkill, locationX, locationY, playerIsland, devMode)
=end
    kiribati = Island.new(1, "kiribati", 1, 50/4, 50/4, 1.5, 15, 70, 1, 7, 8, false, @devMode)
    kwajaleins = Island.new(2, "kwajaleins", 1, 50/4, 50/4, 1.5, 15, 70, 1, 4, 5, false, @devMode)
    hawaii = Island.new(3, "hawaii", 2, 60/4, 60/4, 1.9, 25, 85, 2, 32, 3, false, @devMode)
    samoa = Island.new(4, "samoa", 0, 40/4, 40/4, 1.7, 15, 70, 1, 21, 14, false, @devMode)
    tokelau = Island.new(5, "tokelau", 0, 30/4, 30/4, 1.6, 10, 60, 2, 15, 12, false, @devMode)
    vanuatu = Island.new(6, "vanuatu", 1, 36/4, 36/4, 1.7, 15, 70, 1, 4, 14, false, @devMode)
    tahiti = Island.new(7, "tahiti", 0, 40/4, 40/4, 1.6, 25, 60, 3, 40, 14, false, @devMode)
    takutea = Island.new(8, "takutea", 0, 40/4, 40/4, 1.6, 25, 60, 3, 33, 15, false, @devMode)
    tuvalu = Island.new(9, "tuvalu", 0, 36/4, 36/4, 1.6, 10, 60, 2, 10, 10, false, @devMode)
    fiji = Island.new(10, "fiji", 1, 40/4, 40/4, 1.6, 15, 70, 1, 11, 16, false, @devMode)
    tonga = Island.new(11, "tonga", 0, 36/4, 36/4, 1.6, 10, 60, 2, 18, 17, false, @devMode)
    tuamotus = Island.new(12, "tuamotus", 1, 40/4, 40/4, 1.6, 15, 70, 3, 50, 15, false, @devMode)
    rapanui = Island.new(13, "rapa nui", 1, 56/4, 56/4, 1.8, 15, 75, 4, 58, 17, false, @devMode)
    aotearoa = Island.new(14, "aotearoa", 2, 56/4, 56/4, 1.9, 20, 85, 3, 6, 21, false, @devMode)

    @islands.push(kiribati, kwajaleins, hawaii, samoa, tokelau,
                  vanuatu, tahiti, takutea, tuvalu, fiji, tonga,
                  tuamotus, rapanui, aotearoa)
  end

  def make_start_window
    setpos(6, 15)
    addstr("Welcome to Pacifica.\n\n\t\tThis is a work-in-progress grand strategy game/simulation, set in the South Pacific.
			\n\n\t\tPress 'a' to select an island and an alliance\n\n\t\tPress 'q' to quit")
    refresh
    ch = getch
    if (ch == "a")
      clear
      make_player_options
    else
      abort("quitting pacifica")
    end
    clear
  end

  def make_player_options
    refresh
    setpos(4, 6)
    addstr("Select your island kingdom:\n\n\t\t1. Kiribati\n\n\t\t2. Kwajaleins\n\n\t\t3. Hawaii\n\n\t\t4. Samoa\n\n\t\t5. Tokelau\n\n\t\t6. Vanuatu\n\n\t\t7. Tahiti\n\n\t\t8. Takutea\n\n\t\t9. Tuvalu\n\n\t\ta. Fiji\n\n\t\tb. Tonga\n\n\t\tc. Tuamotus\n\n\t\td. Rapa Nui\n\n\t\te. Aotearoa")
    refresh
    ch = getch
    if (ch == '1')
      @islands.at(0).setPlayerIsland(true)
      selected = "Kiribati"
      @playerIsland = @islands.at(0)
    elsif (ch == '2')
      @islands.at(1).setPlayerIsland(true)
      selected = "Kwajaleins"
      @playerIsland = @islands.at(1)
    elsif (ch == '3')
      @islands.at(2).setPlayerIsland(true)
      selected = "Hawaii"
      @playerIsland = @islands.at(2)
    elsif (ch == '4')
      @islands.at(3).setPlayerIsland(true)
      selected = "Samoa"
      @playerIsland = @islands.at(3)
    elsif (ch == '5')
      @islands.at(4).setPlayerIsland(true)
      selected = "Tokelau"
      @playerIsland = @islands.at(4)
    elsif (ch == '6')
      @islands.at(5).setPlayerIsland(true)
      selected = "Vanuatu"
      @playerIsland = @islands.at(5)
    elsif (ch == '7')
      @islands.at(6).setPlayerIsland(true)
      selected = "Tahiti"
      @playerIsland = @islands.at(6)
    elsif (ch == '8')
      @islands.at(7).setPlayerIsland(true)
      selected = "Takutea"
      @playerIsland = @islands.at(7)
    elsif (ch == '9')
      @islands.at(8).setPlayerIsland(true)
      selected = "Tuvalu"
      @playerIsland = @islands.at(8)
    elsif (ch == 'a')
      @islands.at(9).setPlayerIsland(true)
      selected = "Fiji"
      @playerIsland = @islands.at(9)
    elsif (ch == 'b')
      @islands.at(10).setPlayerIsland(true)
      selected = "Tonga"
      @playerIsland = @islands.at(10)
    elsif (ch == 'c')
      @islands.at(11).setPlayerIsland(true)
      selected = "Tuamotus"
      @playerIsland = @islands.at(11)
    elsif (ch == 'd')
      @islands.at(12).setPlayerIsland(true)
      selected = "Rapa Nui"
      @playerIsland = @islands.at(12)
    elsif (ch == 'e')
      @islands.at(13).setPlayerIsland(true)
      selected = "Aotearoa"
      @playerIsland = @islands.at(13)
    else
      @islands.at(2).setPlayerIsland(true)
      selected = "Invalid selection, Hawaii auto-selected"
      @playerIsland = @islands.at(2)
    end
    clear
    setpos(4, 6)
    addstr("Select your alliance:\n\n\t\t1. Aqua (+10 pop bonus, +10 wealth bonus, +.1 power bonus) \n\n\t\t2. Palm (+15 pop bonus)\n\n\t\t3. Pearl (+20 wealth bonus)\n\n\t\t4. Obsidian (+0.4 power bonus, +1 ship skill bonus)")
    refresh
    chtwo = getch
    if (chtwo == '1')
      @playerIsland.setTeam("aqua")
    elsif (chtwo == '2')
      @playerIsland.setTeam("palm")
    elsif (chtwo == '3')
      @playerIsland.setTeam("pearl")
    elsif (chtwo == '4')
      @playerIsland.setTeam("obsidian")
    else
      @playerIsland.setTeam("aqua")
    end
    clear
    setpos(4, 6)
    addstr("Island selected: #{selected}\n\t\tAlliance selected: #{@playerIsland.getTeam}\n\n\t\tPress ENTER to begin.")
    getch
    refresh
    ch = nil
    chtwo = nil
  end

  def make_game_window(islands, objects, month, year, time)
    win = Window.new(24, 64, ((42-25)/2)-2, (168-100)/2)
    win.box(?|, ?-)
    @moon = (time+1)%10
    if @moon == 0
      @moon = 10
    end
    moon = @moon

    if @moon == 10
      win.addstr("Moon: #{moon}, Month: #{month}, Year: #{year}")
    else
      win.addstr("Moon:  #{moon}, Month: #{month}, Year: #{year}")
    end


    random_earthquake_generator

    calendar_typhoon_generator

    @objects.each do |object|
      y = object.getLocationY
      x = object.getLocationX
      boatHitX = false
      boatHitY = false
      win.setpos(y, x)
      if (object.class.name == "Earthquake")
        win.attron(color_pair(COLOR_RED)|A_NORMAL)
        win.addstr("E")
        win.attroff(color_pair(COLOR_RED)|A_NORMAL)
      elsif (object.class.name == "Boat")
        #if boat has arrived at destination, effect happens
        if (object.getDx == 0 && object.getDy == 0)
          object.setCurrentCrew(0)
          if (object.getType == "war")
            if (object.getDestinationName == "kiribati")
              @islands.at(0).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "kwajaleins")
              @islands.at(1).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "hawaii")
              @islands.at(2).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "samoa")
              @islands.at(3).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tokelau")
              @islands.at(4).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "vanuatu")
              @islands.at(5).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tahiti")
              @islands.at(6).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "takutea")
              @islands.at(7).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tuvalu")
              @islands.at(8).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "fiji")
              @islands.at(9).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tonga")
              @islands.at(10).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tuamotus")
              @islands.at(11).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "rapa nui")
              @islands.at(12).attacked(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "aotearoa")
              @islands.at(13).attacked(object.getCurrentCrew, object.getKingdomName)
            end
          elsif (object.getType == "trade")
            if (object.getDestinationName == "kiribati")
              @islands.at(0).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "kwajaleins")
              @islands.at(1).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "hawaii")
              @islands.at(2).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "samoa")
              @islands.at(3).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tokelau")
              @islands.at(4).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "vanuatu")
              @islands.at(5).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tahiti")
              @islands.at(6).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "takutea")
              @islands.at(7).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tuvalu")
              @islands.at(8).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "fiji")
              @islands.at(9).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tonga")
              @islands.at(10).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "tuamotus")
              @islands.at(11).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "rapa nui")
              @islands.at(12).traded(object.getCurrentCrew, object.getKingdomName)
            elsif (object.getDestinationName == "aotearoa")
              @islands.at(13).traded(object.getCurrentCrew, object.getKingdomName)
            end
            @islands.each do |island|
              if (island.getName == object.getKingdomName)
                island.setCurrentWealth(10)
              end
            end
          end
          object = nil
        end
        #display boat and decide whether it has been damaged


        if (object != nil)
          if (object.getType == "trade")
            win.attron(color_pair(COLOR_YELLOW)|A_NORMAL)
            win.addstr("T")
            win.attroff(color_pair(COLOR_YELLOW)|A_NORMAL)
          elsif (object.getType == "war")
            win.attron(color_pair(COLOR_MAGENTA)|A_NORMAL)
            win.addstr("W")
            win.attroff(color_pair(COLOR_MAGENTA)|A_NORMAL)
          end
        end

        if (object != nil)
          @hazardLocationsX.each do |hazard|
            if (object.getLocationX == hazard)
              boatHitX = true
            end
          end
          if (boatHitX == true)
            @hazardLocationsY.each do |hazard|
              if (object.getLocationY == hazard)
                boatHitY = true
              end
            end
          end
          if (boatHitY == true)
            object.damage
          end
        end

      elsif (object.class.name == "Typhoon")
        win.attron(color_pair(COLOR_CYAN)|A_NORMAL)
        win.addstr("@")
        if (object.getSize == 1 || object.getSize == 2 || object.getSize == 3)
          win.setpos(y, x-1)
          win.addstr("(")
          win.setpos(y, x+1)
          win.addstr(")")
        end
        if (object.getSize == 2 || object.getSize == 3)
          win.setpos(y, x-2)
          win.addstr("(")
          win.setpos(y, x+2)
          win.addstr(")")
          win.setpos(y-1, x)
          win.addstr("^")
          win.setpos(y+1, x)
          win.addstr("v")
        end
        if (object.getSize == 3)
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
        win.attroff(color_pair(COLOR_CYAN)|A_NORMAL)
      elsif (object.class.name == "Tsunami")
        win.attron(color_pair(COLOR_CYAN)|A_NORMAL)
        win.addstr("~")
        if (object.getSize == 1 || object.getSize == 2 || object.getSize == 3 ||
            object.getSize == 4 || object.getSize == 5)
          win.setpos(y, x-1)
          win.addstr("~")
          win.setpos(y, x+1)
          win.addstr("~")
        end
        if (object.getSize == 2 || object.getSize == 3 || object.getSize == 4 || object.getSize == 5)
          win.setpos(y, x-2)
          win.addstr("~")
          win.setpos(y, x+2)
          win.addstr("~")
        end
        if (object.getSize == 3 || object.getSize == 4 || object.getSize == 5)
          win.setpos(y, x-3)
          win.addstr("~")
          win.setpos(y, x+3)
          win.addstr("~")
        end
        if (object.getSize == 4 || object.getSize == 5)
          win.setpos(y, x-4)
          win.addstr("~")
          win.setpos(y, x+4)
          win.addstr("~")
        end
        if (object.getSize == 5)
          win.setpos(y, x-5)
          win.addstr("~")
          win.setpos(y, x+5)
          win.addstr("~")
        end
      end
      win.attroff(color_pair(COLOR_CYAN)|A_NORMAL)
    end

    @islands.each do |island|
      y = island.getLocationY
      x = island.getLocationX
      landEqX = false
      landEqY = false
      @epicenterLocationsX.each do |eq|
        if (island.getLocationX == eq)
          landEqX = true
        end
      end
      if (landEqX == true)
        @epicenterLocationsY.each do |eq|
          if (island.getLocationY == eq)
            landEqY = true
          end
        end
      end
      if (landEqY == true)
#					island.earthquake
        landEqX = false
        landEqY = false
      end
      win.setpos(y, x)

      win.attron(color_pair(COLOR_GREEN)|A_NORMAL)
      if (@playerIsland.getName == island.getName)
        win.attron(color_pair(COLOR_WHITE)|A_NORMAL)
      elsif (@playerIsland.getEnemies.include?(island) && @enemiesRed == true)
        win.attron(color_pair(COLOR_RED)|A_NORMAL)
      elsif (@playerIsland.getAllies.include?(island) && @alliesBlue == true)
        win.attron(color_pair(COLOR_BLUE)|A_NORMAL)
      end

      #Kingdom-specific graphics start now
      if (island.getName == "kiribati")
        win.addstr("*")
        win.setpos(y-1, x)
        win.addstr(".")
        win.attron(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y, x+2)
          win.addstr("kiribati")
        end
      end

      if (island.getName == "kwajaleins")
        win.addstr("*")
        win.setpos(y, x-1)
        win.addstr("'")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y-1, x+1)
          win.addstr("kwajaleins")
        end
      end

      if (island.getName == "hawaii")
        win.addstr("*O")
        win.setpos(y-1, x-1)
        win.addstr(",")
        win.setpos(y-1, x -3)
        win.addstr(".")
        win.setpos(y-1, x-5)
        win.addstr("'")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("hawaii")
        end
      end

      if (island.getName == "samoa")
        win.addstr("*")
        win.setpos(y, x-1)
        win.addstr("o")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("samoa")
        end
      end

      if (island.getName == "tokelau")
        win.addstr("*")
        win.setpos(y-1, x-1)
        win.addstr(".")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("tokelau")
        end
      end

      if (island.getName == "tuvalu")
        win.addstr("*")
        win.setpos(y, x+1)
        win.addstr(".")
        win.setpos(y, x-1)
        win.addstr("'")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-3)
          win.addstr("tuvalu")
        end
      end

      if (island.getName == "vanuatu")
        win.addstr("*")
        win.setpos(y, x+1)
        win.addstr(".")
        win.setpos(y, x+2)
        win.addstr("o")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("vanuatu")
        end
      end

      if (island.getName == "fiji")
        win.addstr("*")
        win.setpos(y-1, x+1)
        win.addstr(",")
        win.setpos(y, x-1)
        win.addstr("'")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("fiji")
        end
      end

      if (island.getName == "tonga")
        win.addstr("*")
        win.setpos(y-1, x)
        win.addstr(".")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("tonga")
        end
      end

      if (island.getName == "takutea")
        win.addstr("*")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-3)
          win.addstr("takutea")
        end
      end

      if (island.getName == "tahiti")
        win.addstr("*")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-2)
          win.addstr("tahiti")
        end
      end

      if (island.getName == "tuamotus")
        win.addstr("*")
        win.setpos(y, x+2)
        win.addstr(",")
        win.setpos(y-1, x-1)
        win.addstr(".")
        win.setpos(y+1, x+1)
        win.addstr("'")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y-2, x-4)
          win.addstr("tuamotus")
        end
      end

      if (island.getName == "rapa nui")
        win.addstr("* o")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x-4)
          win.addstr("rapa nui")
        end
      end

      if (island.getName == "aotearoa")
        win.addstr("oo*")
        win.setpos(y-1, x-1)
        win.addstr(".")
        win.setpos(y+1, x-1)
        win.addstr("ooo")
        win.attroff(color_pair(COLOR_WHITE)|A_NORMAL)
        if (@mapMode == true)
          win.setpos(y+1, x+4)
          win.addstr("aotearoa")
        end
      end
      #End kingdom graphics
    end

    win.refresh

    handle_objects(@objects)
    handle_kingdoms(@islands)
    win.close
  end

  def handle_objects(objects)
    @objects.each do |object|
      if (!(object.class.name == "Earthquake"))
        object.move
      end
    end
  end

  def random_earthquake_generator
    prob = rand(100)
    if (prob%33 == 0)
      epiX = rand(50 - 3) +3
      epiY = rand(18 - 1) +1
      sz = rand(4-1) + 1
      earthquake1 = Earthquake.new(sz, epiX, epiY, @currentTime)
      earthquake1.spawnTsunamis
      earthquake1.getTsunamisList.each do |tsunami|
        addObject(tsunami)
      end
      addObject(earthquake1)
    elsif (prob % 49 == 0)
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
      if (@moon == 1 && ((@month == "jan" && @year != 500) || @month == "jul"))
        island.biyearlyPay
      end
      if (@moon == 1 && @month == "jan")
        island.yearlyPopExplosion
      end
      if (island.getPlayerIsland == false && island.getDefeated == false)
        island.think(@islands, nil, nil, @year, @month, @moon, @time)
      elsif (island.getPlayerIsland == true && island.getDefeated == false)
        island.think(@islands, @playerOption, island.getPlayerState, @year, @month, @moon, @time)
      end
    end
    @islands.each do |island|
      island.getActiveTradeBoats.each do |boat|
        if (@objects.include?(boat) == false)
          addObject(boat)
        end
      end
      island.getActiveWarBoats.each do |boat|
        if (@objects.include?(boat) == false)
          addObject(boat)
        end
      end
    end

    @palmAlliance.clear
    @obsidianAlliance.clear
    @pearlAlliance.clear
    @aquaAlliance.clear
    #Adding to teams and balancing if necessary. Max alliance size is 4
    @islands.each do |island|
      if (island.getTeam == "pearl" && @pearlAlliance.size < 6)
        @pearlAlliance.push(island)
        island.setTeam("pearl")
      elsif (island.getTeam == "obsidian" && @obsidianAlliance.size < 6)
        @obsidianAlliance.push(island)
        island.setTeam("obsidian")
      elsif (island.getTeam == "palm" && @palmAlliance.size < 6)
        @palmAlliance.push(island)
        island.setTeam("palm")
      else
        @aquaAlliance.push(island)
        island.setTeam("aqua")
      end
    end
  end

=begin
		Reminder:
		Jan - 50% chance of 1
		Feb - 20% chance of 1
		Mar - 40% chance of 1
		Apr - 60% chance of 1
		May - 1 - 2
		Jun - 1 - 2
		Jul - 3 - 4
		Aug - 5 - 6
		Sep - 4 - 5
		Oct - 4
		Nov - 2 - 3
		Dec - 1 - 2
=end

  def make_large_typhoon
    sz = 3
    sX = rand(66-10) + 10
    sY = rand(24-1) + 1
    dX = rand(11-2) + 2
    dY = rand(4-1) + 1
    typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
    addObject(typhoon1)
  end

  def make_small_typhoon
    sz = rand(3)
    sX = rand(60-11) + 11
    sY = rand(23-1) + 1
    dX = rand(10-3) + 3
    dY = rand(3-1) + 1
    typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
    addObject(typhoon1)
  end

  def calendar_typhoon_generator
    if (@month == "jan")
      r = rand(20)
      if (r == 1)
        make_small_typhoon
      end
    elsif (@month == "feb")
      r = rand(50)
      if (r == 1)
        make_small_typhoon
      end
    elsif (@month == "mar")
      r = rand(50)
      if (r < 2)
        make_small_typhoon
      end
    elsif (@month == "apr")
      r = rand(50)
      if (r < 4)
        if (r == 1)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "may")
      r = rand(100)
      if (r < 12/3)
        if (r < 1)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "jun")
      r = rand(100)
      if (r < 18/3)
        if (r < 2)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "jul")
      r = rand(100)
      if (r < 39/3)
        if (r < 5)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "aug")
      r = rand(100)
      if (r < 57/3)
        if (r < 8)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "sep")
      r = rand(100)
      if (r < 51/3)
        if (r < 7)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "oct")
      r = rand(100)
      if (r < 42/3)
        if (r < 5)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "nov")
      r = rand(100)
      if (r < 27/3)
        if (r < 2)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    elsif (@month == "dec")
      r = rand(100)
      if (r < 12/3)
        if (r < 1)
          make_large_typhoon
        else
          make_small_typhoon
        end
      end
    end
  end


# This method will not be used in actual gameplay/final implementation
  def random_typhoon_generator

    #Normal Typhoon
    r = rand(50) #Currently:  1/50 chance
    if (r%49 == 0)
      sz = rand(3)
      sX = rand(40-12) + 12
      sY = rand(12-1) + 1
      dX = rand(10-3) + 3
      dY = rand(2-1) + 1
      typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
      addObject(typhoon1)
    end
    #Strong Typhoon
    r = rand(90) #Currently:  1/90 chance
    if (r%89 == 0)
      sz = 3
      sX = rand(46-12) + 12
      sY = rand(12-1) + 1
      dX = rand(11-3) + 3
      dY = rand(2-1) + 1
      typhoon1 = Typhoon.new(sz, sX, sY, dX, dY, @currentTime)
      addObject(typhoon1)
    end
  end

  def make_kingdom_info_window
    kinfo = Window.new(4, 48, 33, (168-100)/2+64)
    kinfo.box(?|, ?-)
    kinfo.setpos(0, 1)
    kinfo.addstr("Your Kingdom")
    kinfo.setpos(1, 1)
    kinfo.addstr("#{@playerIsland.getName.slice(0, 1).capitalize+@playerIsland.getName.slice(1..-1)}\t\tAlliance: #{@playerIsland.getTeam.slice(0, 1).capitalize+@playerIsland.getTeam.slice(1..-1)}")
    kinfo.setpos(2, 1)
    kinfo.addstr("$: #{@playerIsland.getCurrentWealth.to_i}\tP: #{@playerIsland.getPopulation}/#{@playerIsland.getPopCap}\tPow: #{@playerIsland.getPower}\tShip: #{@playerIsland.getShipGuildSkill}")
    kinfo.setpos(3, 1)
    kinfo.addstr("Boats sent: #{@playerIsland.getBoatsSent}")
    kinfo.refresh
  end

  def make_diplomacy_window(islands)
    @playerOption = nil
    winfo = Window.new(7, 64, 30, (168-100)/2)
    raw
    winfo.box(?|, ?=)
    winfo.setpos(0, 1)
    winfo.keypad = true
    if (@diplomacyState == "main")
      @selectionMade = false
      winfo.setpos(1, 1)
      winfo.addstr("t. trade canoe \t\t\tw. war canoe")
      winfo.setpos(2, 1)
      winfo.addstr("m. island names on\t\t\tp. pray [#{@playerPrayersThisYear}/5 per year]")
      winfo.setpos(3, 1)
      winfo.addstr("u/i. toggle info window left/right \t[,] for random trade ")
      winfo.setpos(4, 1)
      winfo.addstr("a. show allies in blue (#{@alliesText})\t\t[.] for random war")
      winfo.setpos(5, 1)
      winfo.addstr("e. show enemies in red (#{@enemiesText}) \t\t active canoes: #{@playerIsland.getActiveTradeBoats.size + @playerIsland.getActiveWarBoats.size}/2")
      winfo.refresh
      ch = getch
      if (ch == 'q')
        abort("quit pacifica")
      else
        if (ch == 't')
          if ((@playerIsland.getActiveTradeBoats.size + @playerIsland.getActiveWarBoats.size) < 2)
            @diplomacyState = "sendingTrade"
            @playerIsland.setPlayerState("sendingTrade")
          end
          ch = nil
        elsif (ch == 'w')
          if ((@playerIsland.getActiveTradeBoats.size + @playerIsland.getActiveWarBoats.size) < 2)
            @diplomacyState = "sendingWar"
            @playerIsland.setPlayerState("sendingWar")
          end
          ch = nil
        elsif (ch == 'p')
          if (@playerPrayersThisYear <= 4)
            @diplomacyState = "praying"
            @playerPrayersThisYear = @playerPrayersThisYear + 1
            @playerIsland.setPlayerState("praying")
          end
        elsif (ch == 'm')
          if (@mapMode == false)
            @mapMode = true
          elsif (@mapMode == true)
            @mapMode = false
          end
        elsif (ch == 'i')
          if (@infoState == "kingdoms")
            @infoState = "events"
            #clearing all island event lists
            @eventsMaster.clear
            @islands.each do |island|
              island.getEvents.clear
            end
          elsif (@infoState == "events")
            @infoState = "allies"
          elsif (@infoState == "allies")
            @infoState = "help"
          elsif (@infoState == "help")
            @infoState = "kingdoms"
          end
        elsif (ch == 'u')
          if (@infoState == "kingdoms")
            @infoState = "help"
          elsif (@infoState == "events")
            @infoState = "kingdoms"
          elsif (@infoState == "allies")
            @infoState = "events"
            #clearing all island event lists
            @eventsMaster.clear
            @islands.each do |island|
              island.getEvents.clear
            end
          elsif (@infoState == "help")
            @infoState = "allies"
          end
        elsif (ch == 'a')
          if (@alliesBlue == false)
            @alliesBlue = true
            @alliesText = "ON"
          elsif (@alliesBlue == true)
            @alliesBlue = false
            @alliesText = "OFF"
          end
        elsif (ch == 'e')
          if (@enemiesRed == false)
            @enemiesRed = true
            @enemiesText = "ON"
          elsif (@enemiesRed == true)
            @enemiesRed = false
            @enemiesText = "OFF"
          end
        elsif (ch == ',')
          @playerIsland.sendTradeToRandomAlly
        elsif (ch == '.')
          @playerIsland.sendWarToRandomEnemy
        elsif (ch == KEY_UP && @islandSelectedAlliesAndEnemiesIndex > 0)
          @islandSelectedAlliesAndEnemiesIndex -= 1
          @islandSelectedAlliesAndEnemies = @islands.at(@islandSelectedAlliesAndEnemiesIndex)
        elsif (ch == KEY_DOWN && @islandSelectedAlliesAndEnemiesIndex < 13)
          @islandSelectedAlliesAndEnemiesIndex += 1
          @islandSelectedAlliesAndEnemies = @islands.at(@islandSelectedAlliesAndEnemiesIndex)
        elsif (ch == KEY_LEFT)
          if (@islandSelectedAlliesAndEnemiesIndex >= 0 && @islandSelectedAlliesAndEnemiesIndex <= 4)
            @islandSelectedAlliesAndEnemiesIndex += 10
          elsif (@islandSelectedAlliesAndEnemiesIndex >= 5 && @islandSelectedAlliesAndEnemiesIndex <= 9)
            @islandSelectedAlliesAndEnemiesIndex -= 5
          else
            @islandSelectedAlliesAndEnemiesIndex -= 5
          end
          if (@islandSelectedAlliesAndEnemiesIndex >= 14)
            @islandSelectedAlliesAndEnemiesIndex = 13
          end
          @islandSelectedAlliesAndEnemies = @islands.at(@islandSelectedAlliesAndEnemiesIndex)
        elsif (ch == KEY_RIGHT)
          if (@islandSelectedAlliesAndEnemiesIndex >= 0 && @islandSelectedAlliesAndEnemiesIndex <= 4)
            @islandSelectedAlliesAndEnemiesIndex += 5
          elsif (@islandSelectedAlliesAndEnemiesIndex >= 5 && @islandSelectedAlliesAndEnemiesIndex <= 9)
            @islandSelectedAlliesAndEnemiesIndex += 5
          else
            @islandSelectedAlliesAndEnemiesIndex -= 10
          end
          if (@islandSelectedAlliesAndEnemiesIndex >= 14)
            @islandSelectedAlliesAndEnemiesIndex = 13
          end
          @islandSelectedAlliesAndEnemies = @islands.at(@islandSelectedAlliesAndEnemiesIndex)
        end
      end
    elsif (@diplomacyState == "sendingTrade")
      winfo.setpos(1, 1)
      winfo.addstr("select where you would like to send a trade boat:")
      winfo.setpos(3, 1)
      winfo.addstr("( view allies & enemies window for details )")
      winfo.refresh
      ch2 = getch
      ch = getch
      @playerOption = ch
      winfo.refresh
      if (ch == 'q')
        abort("quit pacifica")
      end
      @diplomacyState = "main"
      playerIsland.setPlayerState("default")
    elsif (@diplomacyState == "sendingWar")
      winfo.setpos(1, 1)
      winfo.addstr("select where you would like to send a war boat:")
      winfo.setpos(3, 1)
      winfo.addstr("( view allies & enemies window for details )")
      winfo.refresh
      ch2 = getch
      ch = getch
      @playerOption = ch
      winfo.refresh
      if (ch == 'q')
        abort("quit pacifica")
      end
      @diplomacyState = "main"
      playerIsland.setPlayerState("default")
    elsif (@diplomacyState == "praying")
      if (@selectionMade == false)
        winfo.setpos(1, 1)
        winfo.addstr("We are calling to the gods. You must choose:")
        winfo.setpos(2, 1)
        winfo.addstr("1. Human Sacrifice")
        winfo.setpos(3, 1)
        winfo.addstr("2. Offering of Wealth")
        winfo.setpos(4, 1)
        winfo.addstr("3. Relinquishing of Power")
        winfo.refresh
      end
      ch = getch
      if (ch == 'q')
        abort("quit pacifica")
      else
        @selectionMade = true
        if (ch == '1')
          r = rand(20)
          if (r < 5)
            winfo.setpos(2, 1)
            winfo.addstr("The gods grant you wealth! (press any key)")
            @playerIsland.setCurrentWealth(15)
            @playerIsland.setPopulation(-3)
          elsif (r < 15 && @playerIsland.getPopulation > 1)
            winfo.setpos(2, 1)
            winfo.addstr("The gods replace 3 lives with 10! (press any key)")
            @playerIsland.setPopulation(7)
          elsif (r == 18)
            winfo.setpos(2, 1)
            winfo.addstr("The gods rain death from the skies! (press any key)")
            @playerIsland.setPopulation(-3)
            for i in 1..2
              make_small_typhoon
              make_large_typhoon
            end
          else
            winfo.setpos(2, 1)
            winfo.addstr("The gods do not hear your plea! (press any key)")
            @playerIsland.setPopulation(-3)
          end
          winfo.refresh
          ch2 = getch
          @diplomacyState = "main"
        elsif (ch == '2')
          r = rand(20)
          if (r < 10 && @playerIsland.getCurrentWealth > 10)
            winfo.setpos(2, 1)
            winfo.addstr("The gods grant you fertility! (press any key)")
            @playerIsland.setCurrentWealth(-10)
            @playerIsland.setPopulation(10)
          elsif (r < 15 && @playerIsland.getCurrentWealth > 10)
            winfo.setpos(2, 1)
            winfo.addstr("The gods replace 10 shells with 30! (press any key)")
            @playerIsland.setCurrentWealth(20)
          elsif (r == 18 && @playerIsland.getCurrentWealth > 10)
            winfo.setpos(2, 1)
            winfo.addstr("The gods bring death from below! (press any key)")
            @playerIsland.setCurrentWealth(-10)
            for i in 1..80
              random_earthquake_generator
            end
          else
            winfo.setpos(2, 1)
            if (@playerIsland.getCurrentWealth > 10)
              winfo.addstr("The gods do not hear your plea! (press any key)")
              @playerIsland.setCurrentWealth(-10)
            else
              winfo.addstr("Your kingdom is too poor to offer wealth! (press any key)")
            end
          end
          winfo.refresh
          ch2 = getch
          @diplomacyState = "main"
        elsif (ch == '3')
          r = rand(20)
          if (r < 5)
            winfo.setpos(2, 1)
            winfo.addstr("The gods bring you loyal people! (press any key)")
            @playerIsland.setPopulation(30)
            @playerIsland.setPower(-0.1)
          elsif (r < 10)
            winfo.setpos(2, 1)
            winfo.addstr("The gods rain terror from the skies! (press any key)")
            @playerIsland.setPower(-0.1)
            for i in 1..3
              make_small_typhoon
              make_large_typhoon
            end
          elsif (r == 18 || r == 17)
            winfo.setpos(2, 1)
            winfo.addstr("The gods bring death to all from below!")
            @playerIsland.setPower(-0.1)
            for i in 1..100
              random_earthquake_generator
            end
          elsif (r == 12 || r == 13)
            winfo.setpos(2, 1)
            winfo.addstr("The gods bring you great wealth!")
            @playerIsland.setPower(-0.1)
            @playerIsland.setCurrentWealth(60)
          else
            winfo.setpos(2, 1)
            winfo.addstr("The gods do not hear your plea!")
            @playerIsland.setPower(-0.1)
          end
          winfo.refresh
          ch2 = getch
          @diplomacyState = "main"
        elsif (ch != nil)
          winfo.refresh
          @diplomacyState = "main"
          @selectionMade = true
        end
      end
    end
  end


  def make_info_window(islands)
    info = Window.new(27, 48, (((42-25)/2)-2), 64+((168-100)/2))
    info.box(?|, ?-)
    x = 1
    y = 0
    info.setpos(y, x)
    if (@infoState == "kingdoms")
      info.addstr("---|Kingdoms|-Events--Allies & Enemies---Help-")
      y += 2
      info.setpos(y, x)
      info.addstr("Kingdom\tWealth\tPow\tShip\tPop/Cap")
      y += 1
      info.setpos(y, x)
      info.addstr("--------------------------------------aqua")
      @islands.each do |island|
        if (island.getTeam == "aqua")
          y += 1
          info.setpos(y, x)
          if (island.getDefeated == true)
            info.addstr("#{island.getName} - DEFEATED")
          elsif (island.getName.size < 7)
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          else
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          end
        end
      end
      y += 1
      info.setpos(y, x)
      info.addstr("-----------------------------------------palm")
      @islands.each do |island|
        if (island.getTeam == "palm")
          y += 1
          info.setpos(y, x)
          if (island.getDefeated == true)
            info.addstr("#{island.getName} - DEFEATED")
          elsif (island.getName.size < 7)
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          else
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          end
        end
      end
      y += 1
      info.setpos(y, x)
      info.addstr("----------------------------------------pearl")
      @islands.each do |island|
        if (island.getTeam == "pearl")
          y += 1
          info.setpos(y, x)
          if (island.getDefeated == true)
            info.addstr("#{island.getName} - DEFEATED")
          elsif (island.getName.size < 7)
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          else
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          end
        end
      end
      y += 1
      info.setpos(y, x)
      info.addstr("-------------------------------------obsidian")
      @islands.each do |island|
        if (island.getTeam == "obsidian")
          y += 1
          info.setpos(y, x)
          if (island.getDefeated == true)
            info.addstr("#{island.getName} - DEFEATED")
          elsif (island.getName.size < 7)
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          else
            info.addstr("#{island.getName.slice(0, 1).capitalize+island.getName.slice(1..-1)}\t$#{island.getCurrentWealth.to_i}\t#{island.getPower}\t#{island.getShipGuildSkill}\t#{island.getPopulation}/#{island.getPopCap}")
          end
        end
      end
      info.refresh
    end
    if (@infoState == "events")
      info.addstr("----Kingdoms-|Events|-Allies & Enemies---Help-")
      y = 2
      @eventsMaster.each do |event|
        info.setpos(y, 48)
        info.addstr("#{event.getString[0..44]} !")
        y+=1
      end
      info.refresh
    end
    if (@infoState == "allies")
      info.addstr("----Kingdoms--Events-|Allies & Enemies|--Help-")
      info.setpos(1, 1)
      info.attron(color_pair(COLOR_GREEN)|A_NORMAL)
      info.addstr("     (use arrow keys to change selection)     ")
      #Set selected island for allies & enemies screen to the first island
      @islandSelectedAlliesAndEnemies = @islands.at(@islandSelectedAlliesAndEnemiesIndex)
      @islands.each do |island|
        islandName = island.getName
        sendShipChar = 'x'
        case islandName
          when "kiribati"
            y = 2
            x = 2
            sendShipChar = '0'
          when "kwajaleins"
            y += 2
            sendShipChar = '1'
          when "hawaii"
            y += 2
            sendShipChar = '2'
          when "samoa"
            y += 2
            sendShipChar = '3'
          when "tokelau"
            y += 2
            sendShipChar = '4'
          when "vanuatu"
            y = 2
            x = 17
            sendShipChar = '5'
          when "tahiti"
            y += 2
            sendShipChar = '6'
          when "takutea"
            y += 2
            sendShipChar = '7'
          when "tuvalu"
            y += 2
            sendShipChar = '8'
          when "fiji"
            y += 2
            sendShipChar = '9'
          when "tonga"
            y = 2
            x = 33
            sendShipChar = '-'
          when "tuamotus"
            y += 2
            sendShipChar = '+'
          when "rapa nui"
            y += 2
            sendShipChar = '['
          when "aotearoa"
            y += 2
            sendShipChar = ']'
        end
        if (@islandSelectedAlliesAndEnemies.getName == islandName)
          info.attron(color_pair(COLOR_YELLOW)|A_NORMAL)
        elsif (@islandSelectedAlliesAndEnemies.getAllies.any? { |island| island.getName == islandName })
          info.attron(color_pair(COLOR_BLUE)|A_NORMAL)
        elsif (@islandSelectedAlliesAndEnemies.getEnemies.any? { |island| island.getName == islandName })
          info.attron(color_pair(COLOR_RED)|A_NORMAL)
        else
          info.attron(color_pair(COLOR_WHITE)|A_NORMAL)
        end
        info.setpos(y, x)
        info.addstr("#{sendShipChar} #{islandName.slice(0, 1).capitalize+islandName.slice(1..-1)}")
      end
      info.attron(color_pair(COLOR_WHITE)|A_NORMAL)
      info.setpos(11, 1)
      info.addstr("----------------------------------------------")
      info.setpos(12, 1)
      y = 12
      x = 5
      combinedCount = 0
      info.addstr("      Allies and Enemies of your Kingdom      ")
      @playerIsland.getAllies.each do |ally|
        islandName = ally.getName
        case islandName
          when "kiribati"
            sendShipChar = '0'
          when "kwajaleins"
            sendShipChar = '1'
          when "hawaii"
            sendShipChar = '2'
          when "samoa"
            sendShipChar = '3'
          when "tokelau"
            sendShipChar = '4'
          when "vanuatu"
            sendShipChar = '5'
          when "tahiti"
            sendShipChar = '6'
          when "takutea"
            sendShipChar = '7'
          when "tuvalu"
            sendShipChar = '8'
          when "fiji"
            sendShipChar = '9'
          when "tonga"
            sendShipChar = '-'
          when "tuamotus"
            sendShipChar = '+'
          when "rapa nui"
            sendShipChar = '['
          when "aotearoa"
            sendShipChar = ']'
        end
        info.attron(color_pair(COLOR_BLUE)|A_NORMAL)
        y += 1
        info.setpos(y, x)
        info.addstr("#{sendShipChar} #{islandName.slice(0, 1).capitalize+islandName.slice(1..-1)}")
        combinedCount = combinedCount + 1
        if (combinedCount > 6 && x == 5)
          y = 12
          x = 25
        end
      end
      y = 12
      @playerIsland.getEnemies.each do |enemy|
        islandName = enemy.getName
        if (x == 5)
          x = 25
        end
        case islandName
          when "kiribati"
            sendShipChar = '0'
          when "kwajaleins"
            sendShipChar = '1'
          when "hawaii"
            sendShipChar = '2'
          when "samoa"
            sendShipChar = '3'
          when "tokelau"
            sendShipChar = '4'
          when "vanuatu"
            sendShipChar = '5'
          when "tahiti"
            sendShipChar = '6'
          when "takutea"
            sendShipChar = '7'
          when "tuvalu"
            sendShipChar = '8'
          when "fiji"
            sendShipChar = '9'
          when "tonga"
            sendShipChar = '-'
          when "tuamotus"
            sendShipChar = '+'
          when "rapa nui"
            sendShipChar = '['
          when "aotearoa"
            sendShipChar = ']'
        end
        info.attron(color_pair(COLOR_RED)|A_NORMAL)
        y += 1
        info.setpos(y, x)
        info.addstr("#{sendShipChar} #{islandName.slice(0, 1).capitalize+islandName.slice(1..-1)}")
        combinedCount = combinedCount + 1
      end
      info.attron(color_pair(COLOR_WHITE)|A_NORMAL)
      info.setpos(23, 1)
      info.addstr("**********************************************")
      info.setpos(24, 1)
      info.addstr("Key:")
      info.setpos(24, 8)
      info.attron(color_pair(COLOR_YELLOW)|A_NORMAL)
      info.addstr("Selected")
      info.setpos(24, 20)
      info.attron(color_pair(COLOR_BLUE)|A_NORMAL)
      info.addstr("Allies")
      info.setpos(24, 29)
      info.attron(color_pair(COLOR_RED)|A_NORMAL)
      info.addstr("Enemies")
      info.setpos(25, 1)
      info.attron(color_pair(COLOR_GREEN)|A_NORMAL)
      info.addstr("     ( 0-9, -, +, [, ] to send boats )      ")
      info.refresh
    end
    if (@infoState == "help")
      info.addstr("----Kingdoms--Events--Allies & Enemies--|Help|")
      info.setpos(2, x)
      info.addstr("      ********* PACIFICA v 0.5 *********")
      info.setpos(3, x)
      info.addstr("      *** This is a work in progress ***")
      info.setpos(4, x)
      info.addstr("      ** @github.com/hetzluh/pacifica **")
      info.setpos(6, x)
      info.addstr("          --> How to send boats: <--")
      info.setpos(7, x)
      info.addstr("'T' - send trade boat / 'W' - send war boat.")
      info.setpos(8, x)
      info.addstr("Then select which island to send to:")
      info.setpos(9, x)
      info.addstr("0 - kiribati   |  7 - takutea")
      info.setpos(10, x)
      info.addstr("1 - kwajaleins |  8 - tuvalu")
      info.setpos(11, x)
      info.addstr("2 - hawaii     |  9 - fiji")
      info.setpos(12, x)
      info.addstr("3 - samoa      |  '-' - tonga")
      info.setpos(13, x)
      info.addstr("4 - tokelau    |  '+' - tuamotus")
      info.setpos(14, x)
      info.addstr("5 - vanuata    |  '[' - rapa nui")
      info.setpos(15, x)
      info.addstr("6 - tahiti     |  ']' - aotearoa")
      info.setpos(22, x)
      info.addstr("**********************************************")
      info.setpos(23, x)
      info.addstr("Key:")
      info.setpos(24, x)
      info.addstr("Island:")
      info.setpos(24, x+8)
      info.attron(color_pair(COLOR_GREEN)|A_NORMAL)
      info.addstr("*")
      info.attroff(color_pair(COLOR_GREEN)|A_NORMAL)
      info.setpos(24, x+11)
      info.addstr("Trade canoe:")
      info.setpos(24, x+24)
      info.attron(color_pair(COLOR_YELLOW)|A_NORMAL)
      info.addstr("T")
      info.attroff(color_pair(COLOR_YELLOW)|A_NORMAL)
      info.setpos(24, x+27)
      info.addstr("War canoe:")
      info.setpos(24, x+38)
      info.attron(color_pair(COLOR_MAGENTA)|A_NORMAL)
      info.addstr("W")
      info.attroff(color_pair(COLOR_MAGENTA)|A_NORMAL)
      info.setpos(25, x)
      info.addstr("Tsunami:")
      info.setpos(25, x+9)
      info.attron(color_pair(COLOR_CYAN)|A_NORMAL)
      info.addstr("~")
      info.attroff(color_pair(COLOR_CYAN)|A_NORMAL)
      info.setpos(25, x+12)
      info.addstr("Earthquake:")
      info.setpos(25, x+24)
      info.attron(color_pair(COLOR_RED)|A_NORMAL)
      info.addstr("E")
      info.attroff(color_pair(COLOR_RED)|A_NORMAL)
      info.setpos(25, x+27)
      info.addstr("Typhoon:")
      info.setpos(25, x+37)
      info.attron(color_pair(COLOR_CYAN)|A_NORMAL)
      info.addstr("(@)")
      info.attroff(color_pair(COLOR_CYAN)|A_NORMAL)
      info.refresh
    end
  end

end


# Begin script of Pacifica (c) simulation and game
Curses.init_screen
Curses.start_color
Curses.init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK)
Curses.init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK)
Curses.init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK)
Curses.init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK)
Curses.init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK)
Curses.init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK)
Curses.init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_BLACK)
Curses.noecho
Curses.stdscr.keypad(true)
fname = "log_pacifica.txt"
somefile = File.open(fname, "w")
begin
  Curses.crmode
  Curses.raw
  pacifica = Pacifica.new

  pacifica.addIslands

  pacifica.make_start_window

  #Now we are going to add to each island's allies & enemies list
  #Everyone in an alliance is an ally/trade partner to everyone else in the alliance, except for neutral
  #Palms and obsidians are enemies at start
  pacifica.getIslands.each do |island1|
    pacifica.getIslands.each do |island2|
      if ((island1.getName != island2.getName) && (island1.getTeam == island2.getTeam))
        island1.addAlly(island2)
      end
      if ((island1.getName != island2.getName) && (island1.getTeam == "palm") && (island2.getTeam == "obsidian"))
        island1.addEnemy(island2)
      end
      if ((island1.getName != island2.getName) && (island1.getTeam == "obsidian") && (island2.getTeam == "palm"))
        island1.addEnemy(island2)
      end
      if ((island1.getName != island2.getName) && (island1.getTeam == "aqua") && (island2.getTeam == "pearl"))
        island1.addEnemy(island2)
      end
      if ((island1.getName != island2.getName) && (island1.getTeam == "pearl") && (island2.getTeam == "aqua"))
        island1.addEnemy(island2)
      end
    end
  end

  #Applying alliance bonuses
  pacifica.getIslands.each do |island|
    if (island.getTeam == "aqua")
      island.setPopulation(10)
      island.setCurrentWealth(10)
      island.setPower(0.1)
    elsif (island.getTeam == "palm")
      island.setPopulation(15)
    elsif (island.getTeam == "pearl")
      island.setCurrentWealth(20)
    elsif (island.getTeam == "obsidian")
      island.setPower(0.4)
      island.setShipSkill(1)
    end
  end

  while TRUE
    objTemp = Array.new
    # size check - tsunamis and storms of size 0 and boats w/ too few crew get removed from list
    pacifica.clearHazards
    pacifica.getObjects.each do |object|
      if (object.class.name == "Earthquake")
        if ((pacifica.getCurrentTime - object.getSpawnTime) < 4 && (pacifica.getCurrentTime - object.getSpawnTime) > 0)
          objTemp.push(object)
          pacifica.addEpicenterX(object.getLocationX)
          pacifica.addEpicenterY(object.getLocationY)
        end
      end
      if (object.class.name == "Tsunami" || object.class.name == "Typhoon")
        if (object.getSize > 0)
          objTemp.push(object)
          if (object.class.name == "Tsunami")
            if (object.getSize == 1)
              pacifica.addHazardX(object.getLocationX-1, object.getLocationX, object.getLocationX+1, nil, nil, nil, nil, nil, nil, nil, nil)
              pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
            elsif (object.getSize == 2)
              pacifica.addHazardX(object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, nil, nil, nil, nil, nil, nil)
              pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
            elsif (object.getSize == 3)
              pacifica.addHazardX(object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, nil, nil, nil, nil)
              pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
            elsif (object.getSize == 4)
              pacifica.addHazardX(object.getLocationX-4, object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, object.getLocationX+4, nil, nil)
              pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
            elsif (object.getSize == 5)
              pacifica.addHazardX(object.getLocationX-5, object.getLocationX-4, object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, object.getLocationX+4, object.getLocationX+5)
              pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
            end
          elsif (object.class.name == "Typhoon")
            if (object.getSize == 1)
              pacifica.addHazardX(object.getLocationX-1, object.getLocationX, object.getLocationX+1, nil, nil, nil, nil, nil, nil, nil, nil)
              pacifica.addHazardY(object.getLocationY, nil, nil, nil, nil, nil, nil, nil, nil)
            elsif (object.getSize == 2)
              pacifica.addHazardX(object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, nil, nil, nil, nil, nil, nil)
              pacifica.addHazardY(object.getLocationY-2, object.getLocationY-1, object.getLocationY, object.getLocationY+1, object.getLocationY+2, nil, nil, nil, nil)
            elsif (object.getSize == 3)
              pacifica.addHazardX(object.getLocationX-3, object.getLocationX-2, object.getLocationX-1, object.getLocationX, object.getLocationX+1, object.getLocationX+2, object.getLocationX+3, nil, nil, nil, nil)
              pacifica.addHazardY(object.getLocationY-3, object.getLocationY-2, object.getLocationY-1, object.getLocationY, object.getLocationY+1, object.getLocationY+2, object.getLocationY+3, nil, nil)
            end
          end
        end
      end
      if (object.class.name == "Boat")
        if (object.getType == "war")
          if (object.getCurrentCrew > 0)
            objTemp.push(object)
          end
        end
        if (object.getType == "trade")
          if (object.getCurrentCrew > 0)
            objTemp.push(object)
          end
        end
      end
    end

    pacifica.setObjects(objTemp)
    #add all islands to islands
    #add island events to master events
    pacifica.getIslands.each do |island|
      island.getEvents.each do |event|
        pacifica.getEvents.push(event)
      end
    end
    pacifica.getEvents.uniq!
    temp = pacifica.getEvents.last(10)
    pacifica.setEvents(temp)
    pacifica.getEvents.sort_by! { |event| event.getTime }
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


    diploThr = Thread.new { pacifica.make_diplomacy_window(pacifica.getIslands) }
    pacifica.make_kingdom_info_window
    pacifica.make_game_window(pacifica.getIslands, pacifica.getObjects, pacifica.getMonth, pacifica.getYear, pacifica.getCurrentTime)
    pacifica.make_info_window(pacifica.getIslands)
    sleep(0.25)
    diploThr.kill
    if (pacifica.getCurrentTime < 120)
      pacifica.setCurrentTime(pacifica.getCurrentTime+1)
    elsif (pacifica.getCurrentTime == 120)
      if(pacifica.getNumberOfDefeatedAlliances == 2)
        alliancesActive = pacifica.getAlliances - pacifica.getDefeatedAlliances
        alliancesActive.each do |myAlliance|
          alliancesActive.each do |enemyAlliance|
            if(myAlliance != enemyAlliance)
            myAlliance.each do |island|
              enemyAlliance.each do |enemyIsland|
                island.addEnemy(enemyIsland)
              end
            end
            end
          end
        end
      end
      pacifica.setPlayerPrayersThisYear(0)
      pacifica.setCurrentTime(0)
      pacifica.setYear((pacifica.getYear+1))
    end
    somefile.puts "Time: #{pacifica.getCurrentTime} Object count: #{ObjectSpace.count_objects}\n"
  end
ensure
  Curses.close_screen
  somefile.close
end


