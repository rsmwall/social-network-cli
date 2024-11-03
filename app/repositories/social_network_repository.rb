# frozen_string_literal: true

require_relative './profile_repository'
require_relative './post_repository'

# class Social Network
class SocialNetwork
  def initialize
    @profile_repo = ProfileRepository.new
    @post_repo = PostRepository.new
  end
end