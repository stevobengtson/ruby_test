Action = Struct.new(:type, :customer, :product, :quantity, :price) do
    self::TYPE_NONE = 0
    self::TYPE_REGISTER = 1
    self::TYPE_CHECKIN = 2
    self::TYPE_ORDER = 3
end

class LineActionParser
    def initialize(manager)
        @manager = manager
    end

    def parse(line)
        action = self.parseAction(line)
        @manager.process(action)
    end

    def parseAction(line)
        case line
        when /^register\s+(\w+)\s+\$?(-?\d+\.\d{0,2})/i
            Action.new(Action::TYPE_REGISTER, nil, $1, nil, $2.to_f)
        when /^checkin\s+(\w+)\s+(\d+)/i
            Action.new(Action::TYPE_CHECKIN, nil, $1, $2.to_i)
        when /^order\s+(\w+)\s+(\w+)\s+(\d+)/i
            Action.new(Action::TYPE_ORDER, $1, $2, $3.to_i)
        else
            Action.new(Action::TYPE_NONE)
        end
    end
end