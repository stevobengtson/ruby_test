require "minitest/autorun"
require_relative "../../../app/models/Product"
require_relative "../../../app/models/Order"

class OrderTest < Minitest::Test
    def test_initialize
        product = Product.new('test_product', 9.99, 10)
        order = Order.new(product, 5)
        assert_equal 5, order.quantity
        assert_equal product, order.product
    end
end