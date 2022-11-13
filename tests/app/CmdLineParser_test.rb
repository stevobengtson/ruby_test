require "minitest/autorun"
require_relative "../../app/CmdLineParser"

class CmdLineParserTest < Minitest::Test
    def test_parse
        options = CmdLineParser.parse ["--fileName=test.txt"]
        assert_equal 'test.txt', options.fileName
    end
end
