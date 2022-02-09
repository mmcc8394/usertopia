source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails'
gem 'pg'
gem 'sass-rails'
gem 'webpacker'
gem 'turbolinks'
gem 'bootstrap'
gem 'jquery-rails'
gem 'octicons'
gem 'octicons_helper'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'aws-sdk-s3', require: false
gem 'image_processing'

gem 'bcrypt'
gem 'pundit'
gem 'enumerize'
gem 'ranked-model'

gem 'bootsnap', require: false

# Use Puma as the app server
#gem 'puma'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :test do
  gem 'webmock'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'launchy'
  gem 'letter_opener'

  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-delayed-job'
end
