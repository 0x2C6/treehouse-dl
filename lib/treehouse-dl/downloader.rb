require_relative 'runner'
require 'selenium-webdriver'
require 'shell'
require 'mechanize'
require 'spinning_cursor'
require 'corol'
require 'parameterize'
require 'fileutils'


module Treehouse
  class Downloader
    def self.valid(url)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options
      driver.navigate.to url
      course_page = driver.page_source
      course_page_paths = course_page.split(' ').select{ |i| i =~ /library/ }.select{ |i| i =~ /href/ }.uniq
      course_page_paths = course_page_paths.each do |i|
        i[0..5] = ""
        i[i.size - 2..i.size] = ""
      end
        Downloader.download(url,course_page_paths)
    end

    def self.login(username,password)
      SpinningCursor.run do
        banner "Logging in, please wait".green
        type :dots

        action do
          $agent = Mechanize.new
          page = $agent.get('https://teamtreehouse.com/signin')
          form = page.forms[0]
          form["user_session[email]"] = username
          form["user_session[password]"] = password
          page = $agent.submit(form)

          if page.body =~ /Free Trial/
            SpinningCursor.set_message "Email or Password is invalid".red
            return false
          else
            SpinningCursor.set_message "Signed in succesfully".green
            return true
          end
        end
      end
    end

    def self.download(url,paths)
      shift_no = 0
      link_no  = 0
      begin
        while shift_no <= paths.size  do
          full_link = "https://teamtreehouse.com#{paths[shift_no]}"
          shift_no += 1
          download_page_source = $agent.get(full_link)
          video_folder = $agent.get(url).search('//*[@id="syllabus-title"]/h1')
          if download_page_source.body =~ /mp4/
            link_no += 1
            video_name = download_page_source.title
            videolink = download_page_source.body.split(' ').select{|i| i=~/mp4/}[1]
            videolink[0..4] = ""
            videolink.chop!
            Downloader.create_directory("Treehouse",video_folder.text.parameterize)
            SpinningCursor.run do
              banner "Downloading #{video_name}".green
              type :dots
              message "#{video_name} downloaded"
              action do
                system("wget -q -O #{link_no}-#{video_name.parameterize}.mp4 #{videolink}")
              end

            end
          end
        end
      rescue Mechanize::ResponseCodeError
        retry
      end
    end

    def self.create_directory(directory,video_folder)
      FileUtils.cd(ENV["HOME"])
      if File.directory?(directory)
        FileUtils.cd(directory)
        if File.directory?(video_folder)
          FileUtils.cd(video_folder)
        else
          FileUtils.mkdir(video_folder)
          FileUtils.cd(video_folder)
        end
      else
        FileUtils.mkdir(directory)
        FileUtils.cd(directory)
        FileUtils.mkdir(video_folder)
        FileUtils.cd(video_folder)
      end
    end
  end
end
