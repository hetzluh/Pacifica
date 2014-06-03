#!/usr/local/bin/ruby


require 'kingdom.rb'

require "curses"
include Curses

=begin
This class is the simulation's main script
=end

def make_game_window(island, objects)
  win = Window.new(25, 100, ((lines-25)/2)-2, (cols-100)/2)
  win.box(?|, ?-)
	p1 = ((lines - 5) / 2) + 9
	p2 = ((cols - 10) / 2) + 12

	islands.each do |island|

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
 # win.close
end

def make_info_window
  winfo = Window.new(4, 100, 27, (cols-100)/2)
  winfo.box(?|, ?-)
  winfo.setpos(2, 3)
  winfo.refresh
  winfo.refresh
end

init_screen
noecho
begin
    crmode
	islandTest = Island.new(0, "test", 1000, )
	islands.push(islandTest)
	make_info_window
	make_game_window(animals, objects)
ensure
  close_screen
end


