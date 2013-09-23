source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.12'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'libv8'
gem 'mongoid'
gem 'rolify'
gem 'simple_form'
#gem 'sidekiq'
gem 'twitter'
gem "sexmachine" # get gender from firstname
gem 'rufus-scheduler'
gem 'rails_12factor' # Heroku recommended to add this gem
group :assets do
  gem 'less-rails'
  gem 'therubyracer', :platform=>:ruby, :require=>"v8"
  gem 'twitter-bootstrap-rails'
end
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :rbx]
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'awesome_print'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
  gem 'mongoid-rspec'
  gem 'minitest'
end
