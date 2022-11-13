require "minitest/autorun"
require_relative "../../app/LineActionParser"

class LineActionParserTest < Minitest::Test
    def test_parse_register
        [
            { line: 'register hats $20.50', type: Action::TYPE_REGISTER, customer: nil, product: 'hats', quantity: nil, price: 20.50 },
            { line: 'register socks $3.45', type: Action::TYPE_REGISTER, customer: nil, product: 'socks', quantity: nil, price: 3.45 },
            { line: 'register keychain $5.57', type: Action::TYPE_REGISTER, customer: nil, product: 'keychain', quantity: nil, price: 5.57 },
            { line: 'checkin hats 100', type: Action::TYPE_CHECKIN, customer: nil, product: 'hats', quantity: 100, price: nil },
            { line: 'order kate hats 20', type: Action::TYPE_ORDER, customer: 'kate', product: 'hats', quantity: 20, price: nil },
            { line: 'checkin socks 30', type: Action::TYPE_CHECKIN, customer: nil, product: 'socks', quantity: 30, price: nil },
            { line: 'order dan socks 35', type: Action::TYPE_ORDER, customer: 'dan', product: 'socks', quantity: 35, price: nil },
            { line: 'order kate socks 10', type: Action::TYPE_ORDER, customer: 'kate', product: 'socks', quantity: 10, price: nil },
            { line: 'bad', type: Action::TYPE_NONE, customer: nil, product: nil, quantity: nil, price: nil },
        ].each do |test_data|
            action = LineActionParser.parse(test_data[:line])
            assert_equal test_data[:type], action.type
            test_data[:customer].nil? ? assert_nil(action.customer) : assert_equal(test_data[:customer], action.customer)
            test_data[:product].nil? ? assert_nil(action.product) : assert_equal(test_data[:product], action.product)
            test_data[:quantity].nil? ? assert_nil(action.quantity) : assert_equal(test_data[:quantity], action.quantity)
            test_data[:price].nil? ? assert_nil(action.price) : assert_equal(test_data[:price], action.price)
        end
    end
end
