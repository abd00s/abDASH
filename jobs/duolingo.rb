require "watir-webdriver"
Selenium::WebDriver::Chrome.driver_path="/Users/abdoos/Downloads/chromedriver"

# Open a browser
browser = Watir::Browser.new :chrome
# Workaround; password field not visible in phantomjs if not resized
browser.window.resize_to(1124, 850)
# Navigate to desired page
browser.goto("https://www.duolingo.com/")

# Find and click the `login` button
login_button = browser.span :id => "sign-in-btn"
login_button.click

# Enter User info
username_field = browser.text_field :id => "top_login"
username_field.set ENV["DLUN"]

password_field = browser.text_field :id => "top_password"
password_field.set ENV["DLPW"]

# Sign in
submit_login_button = browser.button :id => "login-button"
submit_login_button.click
sleep(2)

## Begin Scrape
# Literacy Percentage
percentage = browser.span(:class => "fluency-score-shield-silver").text.to_i

# Current Streak Length
streak = browser.div(:class => "stat-container").text.to_i

# Total XP in last 7 days
xp_bar = browser.ul :id => "progress-tooltips"

# Extract numerical value of each day
xp_bar_array = []
xp_bar.lis.each{|li| xp_bar_array.push(li.data_original_title.to_i)}

# Sum week's XP
total_xp = xp_bar_array.inject(:+)

# Days since last practiced
days_since_practice =
  if total_xp == 0
    ">7 Days ago!"
  else
    reversed_week = xp_bar_array.reverse
    "#{reversed_week.index{|xp| xp != 0 }} days ago."
  end

# Average skill strength (out of 5)
strength_bar = browser.div(:class => "strengthen-skills-container").a.span(:class => "skill-icon-strength")
strength_bar_class = strength_bar.class_name
average_strength = strength_bar_class[/\d+/].to_i

# Language level
level = browser.span(:class => "skill-tree-header").span.text
level_number = level[/\d+/].to_i

# ## Navigate to 'Activity' tab
# activity_link = browser.li :id => "stream-nav"
# activity_link.click
# sleep(2)

# puts "percentage: #{percentage}"
# puts "streak: #{streak}"
# puts "total_xp: #{total_xp}"
# puts "days_since_practice: #{days_since_practice}"
# puts "average_strength: #{average_strength}"
# puts "level_number: #{level_number}"