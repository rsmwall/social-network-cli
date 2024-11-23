# frozen_string_literal: true

require 'dotenv'
require 'mailtrap'

Dotenv.load(File.expand_path('../../.env', __dir__))

mail = Mailtrap::Mail::Base.new(
  from:
    {
      email: "hello@demomailtrap.com",
      name: "Login Confirmation",
    },
  to: [
    {
      email: ENV['EMAIL_USER'],
    }
  ],
  subject: "Login Confirmation!",
  text: "New login detected in your email!",
  category: "Integration Test"
)

client = Mailtrap::Client.new(
  api_key: ENV['API_KEY'],
)

response = client.send(mail)
puts response
