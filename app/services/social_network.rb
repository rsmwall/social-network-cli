# frozen_string_literal: true

require_relative '../repositories/profile_repository'
require_relative '../repositories/post_repository'

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

  # post methods
  def add_post(params)
    return if params.any? { |_, value| value.nil? } ||
      !@post_repo.search(id: params[:id]).nil?
    
    @post_repo.add(params)
  end

  def search_post(params)
    @post_repo.search(params)
  end
end
