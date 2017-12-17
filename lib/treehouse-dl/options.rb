require 'optparse'

module Treehouse
  $VERSION = '0.1.0'
  class Options

    attr_reader :email
    attr_reader :password
    attr_reader :url

    def initialize(argv)
      parse(argv)
    end
    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: treehouse-dl [options] -e EMAIL -p PASSWORD -u URL"
        opts.on('-e','--email EMAIL','Set email') do |email|
          @email = email
        end
        opts.on('-p','--password PASSWORD','Set password') do |password|
          @password = password
        end
        opts.on('-u','--url URL','Course URL')      do |url|
          @url = url
        end
        opts.on("-h", "--help", "Show all options") do
          puts opts
          exit
        end
        opts.on("-v","--version", "Show version") do
          puts $VERSION
          exit
        end
        begin
          argv = ['-h'] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit
        end
      end
    end
  end
end
