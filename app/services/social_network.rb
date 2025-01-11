# frozen_string_literal: true

require_relative '../repositories/profile_repository'
require_relative '../repositories/post_repository'

# class Social Network
class SocialNetwork
  attr_reader :profile_repo, :post_repo

  def initialize
    @profile_repo = ProfileRepository.new
    @post_repo = PostRepository.new
  end

  # profile methods

  def add_profile(params)
    return false if params.any? { |_, value| value.nil? } ||
      !@profile_repo.search_to_add(user: params[:user], email: params[:email]).nil?
    
    @profile_repo.add(params)
    true
  end

  def search_profile(user, reason)
    if reason == 1
      @profile_repo.search(user)
    elsif reason == 2
      @profile_repo.search_to_add(user: user)
    end
  end

  # post methods

  def add_post(params)
    return false if params.any? { |_, value| value.nil? }
    
    @post_repo.add(params)
    true
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

  def show_post_profile(user)
    profile = search_profile(user, 2)
    all_posts = @post_repo.posts
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
    posts = []
    @post_repo.posts.each do |_, post|
      if post.instance_of?(AdvancedPost) && post.hashtag?(hashtag) && post.remaining_views > 0
          posts << post
          decrement_views(post.id)
      end
    end

    posts
  end

  # persistence methods

  def save_data
    @profile_repo.save
    @post_repo.save
  end

  def load_data
    @profile_repo.load

    profiles = @profile_repo.profiles
    profiles_hash = profiles.transform_keys(&:to_i)

    @post_repo.load(profiles_hash)
  end
end
