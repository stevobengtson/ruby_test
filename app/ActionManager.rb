class ActionManager
    def initialize(dataManager)
        @dataManager = dataManager
    end
 
    def process(action)
        case action.type
        when Action::TYPE_REGISTER
            self.register(action)
        when Action::TYPE_CHECKIN
            self.checkin(action)
        when Action::TYPE_ORDER
            self.order(action)
        end
    end

    def report
        @dataManager.customers.sort_by { |customer| customer.name }.each do |customer|
            output = "#{customer.name}: "
            output += 'n/a' if customer.orders.empty?

            orders = {}
            totalPrice = 0
            customer.orders.sort_by { |order| order.product.name }.each do |order|
                if orders.key?(order.product.name)
                    orders[order.product.name] += order.product.price * order.quantity
                else
                    orders[order.product.name] = order.product.price * order.quantity
                end

                totalPrice += order.product.price * order.quantity
            end

            if totalPrice > 0
                orders.each do |product_name, total_price|
                    output += "#{product_name} - $#{total_price}, "
                end

                output += " | Average Order Value: $" + (totalPrice / orders.count).to_s
            end
            
            p output
        end
    end
   
    private

    def register(action)
        return if @dataManager.getProduct(action.product)
        @dataManager.createProduct(action.product, action.price, action.quantity || 0)
    end

    def checkin(action)
        product = @dataManager.getProduct(action.product)
        return unless product

        product.addQuantity(action.quantity)
    end

    def order(action)
        # Find Customer
        customer = @dataManager.getCustomer(action.customer)
        customer = @dataManager.createCustomer(action.customer) unless customer

        # Find Product
        product = @dataManager.getProduct(action.product)
        return unless product

        # Create Order if we have enough product quantity
        if product.removeQuantity?(action.quantity)
            order = Order.new(product, action.quantity)
            customer.addOrder(order)
        end
    end
end

