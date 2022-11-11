# Code Challenge

## Setup

### Required

ruby 2.7+
bundler 2.1.4+
gem 3.1.2+

bundle config set path 'vendor/bundle'
bundle install

##
I am starting with a simple Ruby console application.

I choose Ruby since I am familar with the language and it is a good OOP language.
There are also many Gems and tools that I can use to help in the development process.

First thing to do is break down what we are trying to accomplish:

1. Load a file
 - need error checking for file existance
2. Read in the file line by line
 - could be a large file, don't read the entire file into an array of strings
 - there is a specific format, we should be able to parse each line base on this format, which could change (regular expressions?)
 - register should probably come before checkin, but doesn't look like an exception
 - checkin should do nothing if item has not been registered? Not specified but base on the spec I would assume so at this point.
 - order should do nothing if item does not exist or does not have enough items, there could be some items though.
3. Output the results
 - Customer: product - $value, ... | Average Order Value: $avgValue

Breakdown the parts (note that there will be a lot of overthinking here that I can trim down as I think through it):
1. Load a file
 - we need to get the file name
 - we need to check we can read it, let user know if not
 - we need to parse each line at a time (streamed to reduce memory usage)
 - Separate class to read and iterate the file?
2. Parse each line
 - Parser class to parse a line - allows for other parsers if we need in the future
3. Store data parsed
 - Persister class to persist data (in-memory) parsed from line - allows us to change were to store the data (memory, redis, database, etc)
 - Provider class to read data
 - Customer Persister
 - Product Persister (also to update number of available)
 - Purchase Persister (linked to customer and product with quantity)
4. Report on data
 - Reporter main class to report on the data

Questions:
1. if a checkin is found but no item registered do we ignore the command like the order if not enough products or do not exist?
  - Assuming yes based on the "Ignore any orders for products that either are not in the warehouse..."
2. Can the product name have any characters (spaces, etc)
  - Assuming no based on the the example
3. Multiple orders of the same product for a customer?

first step is to accept parameters on the command line to know which file to load.
using OptionParser to easily parse and manage command parameters.
Here we want to accept a file name, and indicate an error if they do not specify one.
Also we should give some helpful output to the user if they need to know what options are available (--help)
Here I am putting the parsing into its own class so that it slimplified the management of the code.

Next I need to read in this file, I know I am going to want to process each line one at a time.
Lets create a file loder class that deals with opening and loading the file, I do this so we can have other
services brought in to parse the line and persist the data.

First I will start with the line parser, and just output the results to see what happens
going to use a test file with the data supplied on the code challenge
Using regular expression matcher I can create a simple struct to hold the data, I will call this struct Action
It will hold the data for each action, and can pass that to a manager service to store and manager the data

1. hats <$20.50> (100)
1. hats <$20.50> (0), socks <3.45> (0)
1. hats <$20.50> (0), socks <3.45> (0), keychain <5.57> (0)
1. hats <$20.50> (100), socks <3.45> (0), keychain <5.57> (0)
1. hats <$20.50> (80), socks <3.45> (0), keychain <5.57> (0)
1. hats <$20.50> (80), socks <3.45> (30), keychain <5.57> (0)
1. hats <$20.50> (80), socks <3.45> (30), keychain <5.57> (0)
1. hats <$20.50> (80), socks <3.45> (20), keychain <5.57> (0)
