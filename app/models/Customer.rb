class Customer
    attr_reader :name, :orders

    def initialize(name)
        @name = name
        @orders = []
    end

    def addOrder(order)
        @orders << order
    end

    def averageOrderPrice
        totalPrice = 0
        @orders.each do |order|
            totalPrice += order.product.price * order.quantity
        end

        (totalPrice == 0 ? 0.00 : totalPrice / @orders.count).round(2)
    end

    def getOrderTotalsByProduct
        orderTotalsByProduct = {}
        @orders.sort_by { |order| order.product.name }.each do |order|
            if orderTotalsByProduct.key?(order.product.name)
                # Has previous orders for product so add this ones total
                orderTotalsByProduct[order.product.name] += order.product.price * order.quantity
            else
                # No previous order for product so create new entry
                orderTotalsByProduct[order.product.name] = order.product.price * order.quantity
            end
        end

        orderTotalsByProduct
    end
end