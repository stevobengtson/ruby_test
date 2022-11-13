require "minitest/autorun"
require_relative "../../../app/models/Customer"
require_relative "../../../app/models/Product"
require_relative "../../../app/models/Order"

class CustomerTest < Minitest::Test
    def test_initialize
        customer = Customer.new('test')
        assert_equal 'test', customer.name
        assert_empty customer.orders
    end

    def test_addOrder
        customer = Customer.new('test')
        product = Product.new('test_product', 9.99, 10)
        order = Order.new(product, 5)
        customer.addOrder(order)
        refute_empty customer.orders
        assert_equal order, customer.orders.first
    end

    def test_averageOrderPrice
        customer = Customer.new('test')
        
        product1 = Product.new('test_product1', 9.99, 10)
        customer.addOrder(Order.new(product1, 2))
        customer.addOrder(Order.new(product1, 2))

        assert_equal 19.98, customer.averageOrderPrice

        product2 = Product.new('test_product2', 5.99, 10)
        customer.addOrder(Order.new(product2, 1))
        customer.addOrder(Order.new(product2, 2))

        assert_equal 14.48, customer.averageOrderPrice
    end

    def test_getOrderTotalsByProduct
        customer = Customer.new('test')
        
        product1 = Product.new('test_product1', 9.99, 10)
        customer.addOrder(Order.new(product1, 2))
        customer.addOrder(Order.new(product1, 2))

        orderTotals = customer.getOrderTotalsByProduct
        assert_equal 1, orderTotals.count
        assert_equal 39.96, orderTotals['test_product1']

        product2 = Product.new('test_product2', 5.99, 10)
        customer.addOrder(Order.new(product2, 1))
        customer.addOrder(Order.new(product2, 2))

        orderTotals = customer.getOrderTotalsByProduct
        assert_equal 2, orderTotals.count
        assert_equal 39.96, orderTotals['test_product1']
        assert_equal 17.97, orderTotals['test_product2']
    end
end
