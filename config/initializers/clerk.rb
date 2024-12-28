# config/initializers/clerk.rb
Clerk.configure do |config|
  config.api_key = ENV['CLERK_SECRET_KEY'] # Ensure this environment variable is set
end