require "minitest/autorun"
require_relative "../../../app/models/Product"

class ProductTest < Minitest::Test
    def test_initialize
        product = Product.new('test', 9.99)
        assert_equal 'test', product.name
        assert_equal 9.99, product.price
        assert_equal 0, product.quantity
    end

    def test_addQuantity
        product = Product.new('test', 9.99)
        product.addQuantity(10)
        assert_equal 10, product.quantity
        product.addQuantity(5)
        assert_equal 15, product.quantity
    end

    def test_removeQuantity?
        product = Product.new('test', 9.99)
        product.addQuantity(10)
        refute product.removeQuantity?(20)
        assert_equal 10, product.quantity
        assert product.removeQuantity?(5)
        assert_equal 5, product.quantity
    end
end
