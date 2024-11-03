# frozen_string_literal: true

require_relative './profile_repository'
require_relative './post_repository'

# class Social Network
class SocialNetwork
  def initialize
    @profile_repo = ProfileRepository.new
    @post_repo = PostRepository.new
  end

  # profile methods
  def add_profile(params)
    return if params.any? { |_, value| value.nil? } ||
      !@profile_repo.search(id: params[:id], user: params[:user], email: params[:email]).nil?
    
    @profile_repo.add(params)
  end

  def search_profile(params)
    @profile_repo.search(params)
  end
end
