require_relative 'options'
require_relative 'downloader'
require 'corol'

module Treehouse
  class Runner

    def initialize(argv)
      @opts = Options.new(argv)
    end

    def run
      if !@opts.email.nil? and !@opts.password.nil? and !@opts.url.nil?
        Downloader.valid(@opts.url) if Downloader.login(@opts.email,@opts.password)
      else
        puts "Account and url informations can't be blank".red
        exit
      end
    end
  end
end
