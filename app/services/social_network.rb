# frozen_string_literal: true

require_relative '../repositories/profile_repository'
require_relative '../repositories/post_repository'
require_relative '../controllers/profile_controller'
require_relative '../controllers/post_controller'

# TODO: rupocop conventions

# class Social Network
class SocialNetwork
  attr_reader :profile_repository, :post_repository

  def initialize
    @profile_repository = ProfileRepository.new
    @profile_controller = ProfileController.new
    @post_repository = PostRepository.new
    @post_controller = PostController.new
  end

  # profile methods

  def add_profile(params)
    @profile_controller.add(params, @profile_repository)
  end

  def search_profile(user, reason)
    @profile_controller.search(user, reason, @profile_repository)
  end

  # post methods

  def add_post(params)
    @post_controller.add(params, @post_repository)
  end

  def search_post(params)
    @post_repository.search(params)
  end

  def like(id)
    @post_controller.like(id)
  end

  def dislike(id)
    @post_controller.dislike(id)
  end

  def decrement_views(id)
    @post_controller.decrement_views(id)
  end

  # feed methods

  def show_post_profile(user)
    profile = search_profile(user, 2)
    all_posts = @post_repository.posts
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
    @post_repository.posts.each do |_, post|
      if post.instance_of?(AdvancedPost) && post.hashtag?(hashtag) && post.remaining_views > 0
          posts << post
          decrement_views(post.id)
      end
    end

    posts
  end

  # persistence methods

  def save_data
    @profile_repository.save
    @post_repository.save
  end

  def load_data
    @profile_repository.load

    profiles = @profile_repository.profiles
    profiles_hash = profiles.transform_keys(&:to_i)

    @post_repository.load(profiles_hash)
  end
end
