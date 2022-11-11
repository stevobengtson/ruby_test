require 'optparse'

Options = Struct.new(:fileName)

class CmdLineParser
    def self.parse(options)
      args = Options.new()
  
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: main.rb [options]"
  
        opts.on("-fFILENAME", "--fileName=FILENAME", "File name to load") do |n|
          args.fileName = n
        end
  
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end
  
      opt_parser.parse!(options)
      return args
    end
  end
