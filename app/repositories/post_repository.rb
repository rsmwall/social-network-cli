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
    if params.key?(:hashtags)
      post = AdvancedPost.new(
        {id: @next_id, text: params[:text], likes: params[:likes], dislikes: params[:dislikes],
        date: params[:date], profile: params[:profile]}, params[:hashtags], params[:remaining_views])
    else
      post = Post.new(
        id: @next_id, text: params[:text], likes: params[:likes], dislikes: params[:dislikes],
        date: params[:date], profile: params[:profile]
      )
    end

    @next_id += 1
    @posts[post.id] = post
    post.profile.add(post.id)
  end

  def search(params)
    params = params.reject { |_, value| value.nil? }

    post = []
    @posts.each do |key, value|
      if params.all? do |param_key, param_value|
          case param_key
          when :text
            value.text.include?(param_value)
          when :hashtags
            if value.instance_of?(AdvancedPost)
              value.has_hashtag?(param_value)
              value.decrement_views
            end
          else
            value.send(param_key) == param_value
          end
        end
        post << value
        value.decrement_views if value.instance_of?(AdvancedPost)
      end
    end

    post
  end

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

      if post_hash.key?('hashtags') && post_hash.key?('remaining_views')
        post = AdvancedPost.from_h(post_hash, profile)
      else
        post = Post.from_h(post_hash, profile)
      end

      @posts[post.id] = post
      profile.add(post)
      @next_id = [@next_id, post.id + 1].max
    end
  end
end
