#!/usr/bin/env ruby

require './app/CmdLineParser.rb'
require './app/FileLoader.rb'
require './app/ActionManager.rb'
require './app/LineParser.rb'
require './app/DataManager.rb'
require './app/ActionManager.rb'

options = CmdLineParser.parse ARGV

# Confirm we have a file to load

dataManager = DataManager.new()

actionManager = ActionManager.new(dataManager)

lineActionParser = LineActionParser.new(actionManager)

fileLoader = FileLoader.new(lineActionParser)
fileLoader.load(options[:fileName])

# Dan: n/a
# Kate: hats - $410.00, socks - $34.50 | Average Order Value: $222.25
actionManager.report()
