class FileLoader
    def initialize(lineParser)
        @lineParser = lineParser
    end

    def load(fileName)
        File.foreach(fileName) do |line|
            @lineParser.parse(line)
        end
    end
end
