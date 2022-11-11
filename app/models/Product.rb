class Product
    attr_reader :name, :price, :quantity

    def initialize(name, price, quantity = 0)
        @name = name
        @price = price
        @quantity = quantity
    end

    def addQuantity(quantity)
        @quantity += quantity unless @quantity.nil?
        @quantity = quantity if @quantity.nil?
    end

    def removeQuantity?(quantity)
        return false if @quantity < quantity
        @quantity -= quantity
        return true
    end
end