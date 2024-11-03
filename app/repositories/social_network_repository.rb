# frozen_string_literal: true

require_relative './profile_repository'
require_relative './post_repository'

# class Social Network
class SocialNetwork
  def initialize
    @profile_repo = ProfileRepository.new
    @post_repo = PostRepository.new
  end

  def add_profile(profile)
    return if (profile.id.nil? || profile.user.nil? || profile.email.nil?) ||
      !@profile_repo.search(id: profile.id, user: profile.user, email: profile.email).nil?
    
    @profile_repo.add(profile)
  end

  def search_profile(params)
    @profile_repo.search(params)
  end
end
