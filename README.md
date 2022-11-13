# Code Challenge

## Setup

### Required

ruby 2.7+
bundler 2.1.4+
gem 3.1.2+

```
bundle config set path 'vendor/bundle'
bundle install
bundle binstubs --all
```

## Run

### Test

`bin/rake test`

### Application

`ruby ./main.rb --fileName=test.txt`

or

`bin/rake main -- --fileName=test.txt`

## Process

I am starting with a simple Ruby console application.

I choose Ruby since I am familar with the language and it is a good OOP language.
There are also many Gems and tools that I can use to help in the development process.

First thing to do is break down what we are trying to accomplish:

1. Load a file
 - need error checking for file existance
2. Read in the file
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

1. hats {$20.50} (100)
1. hats {$20.50} (0), socks {3.45} (0)
1. hats {$20.50} (0), socks {3.45} (0), keychain {5.57} (0)
1. hats {$20.50} (100), socks {3.45} (0), keychain {5.57} (0)
1. hats {$20.50} (80), socks {3.45} (0), keychain {5.57} (0)
1. hats {$20.50} (80), socks {3.45} (30), keychain {5.57} (0)
1. hats {$20.50} (80), socks {3.45} (30), keychain {5.57} (0)
1. hats {$20.50} (80), socks {3.45} (20), keychain {5.57} (0)

I will need a storage system for this, I am going to make a DataManager that will store the data as Entities in arrays.
We will have 3 Entities, Customer, Product and Order.
We will have a relationship between Order and Product (each order can have a product, each product can belong to many orders)
We will have a relationship beween Customer and Order (each customer can have many orders, each order belongs to one customer)
Here we can also keep some small helper methods on each entity like adjusting the quantity for a product, and the DataManager
will just store that data (creating the entities if required).

Now I can parse each line of the file into an Action, I will pass this data off to an Action Manager (service)
that will use the data manager to store and update the information as required by the action.
This action manager will hold the main business logic around each action, register, checking and order.

After we have processed the file we need to generate the report, this will be one in the main file as we don't want any of
the other classes to deal with output, they should be unaware of how they are being called (in console, web app etc).

If the output was more complicated I would probably build a separate class but since it is pretty simple it is easier to leave
it in the main file.

## Design
Overall I have tried to keep concerns separate here, and simple.
1. CmdLineParser - That is all it does, along with providing output if the user specifies the help option
1. DataManager - only deals with storing/retrieving the data, note I made access to the data public rather than using getters/find/etc to simplify.
1. LineActionParser - Just parses a line into an action, errors are handled by setting the Action to None, we could put more error handling here if needed.
1. ActionManager - Most of the business logic, deals with an action provided.
1. Models under the models folder, each deals with a specific entity, there is a bit of cross knowledge here (customer knows order has a prdouct which has a price) which I would like to separate a bit further in a bigger application. Possibley to the ActionManager.

## Tests

I created some simple unit tests in this application, it helps uncover a lot of the general bugs in the application. However it would not cover complicated business logic, this application is pretty simple so I don't see a need to over test with some integration testing. If this was a Rails application then I would introduce those, starting with important flows. My Main focus as a developer would be Unit tests first, then Integration and in a Full Stack I would look at End to End tests as well. Less tests as I go out from Unit to E2E as they take longer to run.
