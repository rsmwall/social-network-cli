# frozen_string_literal: true

require_relative './services/social_network'

# class App
class App
  def initialize
    @social_network = SocialNetwork.new
  end
end