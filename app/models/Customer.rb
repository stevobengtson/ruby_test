class Customer
    attr_reader :name, :orders

    def initialize(name)
        @name = name
        @orders = []
    end

    def addOrder(order)
        @orders << order
    end
end