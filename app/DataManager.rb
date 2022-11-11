require './app/models/Product.rb'
require './app/models/Customer.rb'
require './app/models/Order.rb'

class DataManager
    attr_reader :products, :customers

    def initialize()
        @products = []
        @customers = []
    end

    def createProduct(product_name, price, quantity = 0)
        product = Product.new(product_name, price, quantity)
        @products << product
        product
    end

    def getProduct(name)
        @products.detect { |product| product.name === name }
    end

    def addProductQuanitity(product_name, quantity)
        product = self.getProduct(product_name)
        return unless product

        product.addQuanitity(quantity)
    end

    def createCustomer(customer_name)
        customer = Customer.new(customer_name)
        @customers << customer
        customer
    end

    def getCustomer(name)
        @customers.detect { |customer| customer.name === name }
    end
end
