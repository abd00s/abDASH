require "watir-webdriver"
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
# SCHEDULER.every '10m', :first_in => 0 do
  # Specify path to chromdriver
  # Selenium::WebDriver::Chrome.driver_path="/Users/abdoos/Downloads/chromedriver"
  # driver = Selenium::WebDriver.for :chrome

  # Open a browser
  browser = Watir::Browser.new :phantomjs
  # Navigate to desired page
  browser.goto("http://www.cic.gc.ca/english/information/times/")

  # Form Level 1 - Select Application Type
  application_type = browser.select_list :id => "typeapp"
  application_type.select "Permanent Resident cards"

  # Form Level 2 - Answer secondary question
  existing_pr = browser.select_list :id => "prcard"
  existing_pr.select "No (renewing or replacing a PR card)"

  # Locate and click form submit button
  submit_button = browser.button :id => 'ptsubmit'
  submit_button.click

  ## Begin scraping
  # Find average number of days for processing
  number_of_days = browser.div(:id => "tableContent").p.text
  # Parse value
  parsed_number_of_days = number_of_days[/\d+/].to_i

  # To setup regex (January|February|...|December)
  month_names = Date::MONTHNAMES.select{|i| i != nil}
  # Find date of submission of applications being processed
  date_working_on = browser.div(:id => "ptmessage").ps[1].text
  # Parse value
  parsed_date_working_on = date_working_on[/(#{month_names.join('|')}).*/]
  puts parsed_number_of_days
  puts parsed_date_working_on

  # send_event('mine', {current: parsed_number_of_days})
  # send_event('me', {text: "Hey hello what up#{5*3}"})
# end