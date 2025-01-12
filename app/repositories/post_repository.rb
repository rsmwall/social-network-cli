# frozen_string_literal: true

require_relative '../models/post'
require_relative '../models/advanced_post'
require_relative '../models/profile'

# class Post Repository
class PostRepository
  attr_reader :posts

  def initialize
    @posts = {}
    @next_id = 1
  end

  def add(params)
    post = create_post(params)
    save_post(post)
  end

  private

  def create_post(params)
    if params.key?(:hashtags) then AdvancedPost.new(
      { id: @next_id, text: params[:text], likes: params[:likes], dislikes: params[:dislikes],
        date: params[:date], profile: params[:profile] }, params[:hashtags], params[:remaining_views]
    )
    else
      Post.new(
        id: @next_id, text: params[:text], likes: params[:likes], dislikes: params[:dislikes],
        date: params[:date], profile: params[:profile]
      )
    end
  end

  def save_post(post)
    @next_id += 1
    @posts[post.id] = post
    post.profile.add(post.id)
  end

  public

  def search(params)
    params = params.reject { |_, value| value.nil? }

    @posts.each_with_object([]) do |(_, post), result|
      if match_post?(post, params)
        handle_advanced_post(post) if post.instance_of?(AdvancedPost)
        result << post
      end
    end
  end

  private

  def match_post?(post, params)
    params.all? do |param_key, param_value|
      case param_key
      when :text
        post.text.include?(param_value)
      when :hashtags
        post_has_hashtag?(post, param_value)
      else
        post.send(param_key) == param_value
      end
    end
  end

  def post_has_hashtag?(post, hashtag)
    post.instance_of?(AdvancedPost) && post.hashtag?(hashtag)
  end

  def handle_advanced_post(post)
    post.decrement_views
  end

  public

  # persistence

  def save
    data = @posts.map { |_, value| value.to_h }
    Dir.mkdir('app/data') unless Dir.exist?('app/data')
    File.new('app/data/posts.json', 'a')
    File.write('app/data/posts.json', JSON.pretty_generate(data))
  end

  def load(profiles)
    return unless File.exist?('app/data/posts.json')

    data = JSON.parse(File.read('app/data/posts.json'))
    data.each do |post_hash|
      profile = profiles[post_hash['profile_id']]
      next unless profile

      post = create_loaded(post_hash, profile)
      save_loaded(post, profile)
    end
  end

  private

  def create_loaded(post_hash, profile)
    if post_hash.key?('hashtags') && post_hash.key?('remaining_views')
      AdvancedPost.from_h(post_hash, profile)
    else
      Post.from_h(post_hash, profile)
    end
  end

  def save_loaded(post, profile)
    @posts[post.id] = post
    profile.add(post)
    @next_id = [@next_id, post.id + 1].max
  end
end
