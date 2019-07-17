require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'csv'
require 'pry'
require 'colorize'
include URI::Escape

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.app_host = nil
Capybara.page.driver.options[:js_errors] = false
Capybara.page.driver.options[:phantomjs_logger] = $stderr
Capybara.page.driver.options[:phantomjs_options] = ['--load-images=no']

class Scrape
  include Capybara::DSL
  def go
    visit 'https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations'
	CSV.open('State_Abb.csv','w') do |csv|
		loop do
		  begin
			page.all('.monospaced').each do |agent_container|
				abb = agent_container.text
				if abb.length == 2
					begin
						test_int = Integer(abb)
					rescue
						csv << [abb]
					end
				end
			end			
		  rescue Capybara::ElementNotFound
			puts 'wompwomp'
		  end
		end
		csv.close
	  end
  end
end

puts Scrape.new.go