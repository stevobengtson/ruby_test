#!/usr/bin/env ruby

require './app/CmdLineParser.rb'
require './app/ActionManager.rb'
require './app/LineActionParser.rb'
require './app/DataManager.rb'
require './app/ActionManager.rb'

# Parse our command line
options = CmdLineParser.parse ARGV

# Confirm we have a file to load
unless !options.fileName.nil? && File.exists?(options.fileName)
    p "ERROR - Unable to load file #{options.fileName}"
    exit
end

# Load the data manager, like a database connection
dataManager = DataManager.new()
# Load the action manager service, passing the data manager we wish to use (DI)
actionManager = ActionManager.new(dataManager)

# Read in the file line by line and for each one process the action
File.foreach(options.fileName) do |line|
    # Process the action from the line
    action = LineActionParser.parse(line)
    # Pass the action to the action manager to take care of storage and business logic
    actionManager.process(action)
end

# Report on the data collected, each customer sorted by name
dataManager.customers.sort_by { |customer| customer.name }.each do |customer|
    # Basic output, customer name and if there are no orders the n/a string
    output = "#{customer.name}: "
    output += 'n/a' if customer.orders.empty?

    # Total up the order values, this allows for multiple orders on the same prduct for each customer
    orders = customer.getOrderTotalsByProduct

    # If there are orders summarize the information
    unless orders.empty?
        # Output the order data
        output += orders.map{ |product_name, total_price| "#{product_name} - $" + '%.2f' % total_price }.join(', ')
        # Output the average price of all orders
        output += " | Average Order Value: $" + '%.2f' % customer.averageOrderPrice
    end

    # Show our results!
    p output
end
