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

  def like(id)
    post = search_post(id: id)
    post.like if !post.nil?
  end

  def dislike(id)
    post = search_post(id: id)
    post.dislike if !post.nil?
  end

  def decrement_views(id)
    post = search_post(id: id)
    post.decrement_views if !post.nil? && post.instance_of?(AdvancedPost)
  end

  def show_post_profile(id)
    profile = search_profile(id: id)
    all_posts = @post_repo.show_posts
    profile_posts = []
    all_posts.each { |_, value| profile_posts << value if value.profile.id == profile.id }
    
    posts = []
    if !profile.nil?
      profile_posts.each do |post|
        if !post.instance_of?(AdvancedPost)
          posts << post
        elsif post.remaining_views > 0
          decrement_views(post.id)
          posts << post
        end
      end
    end

    posts
  end

  def show_post_by_hashtag(hashtag)
    all_posts = @post_repo.show_posts
    posts = []
    all_posts.each do |_, value| 
      posts << value if 
        value.instance_of?(AdvancedPost) && value.hashtags.include?(hashtag) && value.remaining_views > 0
    end

    posts
  end
end
