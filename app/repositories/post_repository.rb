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
    @post.profile.add(post.id)
  end

  def search(params)
    params = params.reject { |_, value| value.nil? }

    post = nil
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
        post = value
        break
      end
    end

    post
  end

  # persistence

  def save(file_path)
    data = @posts.values.map(&:to_h)
    File.write(file_path, JSON.pretty_generate(data))
  end

  def load(file_path, profiles)
    return unless File.exist?(file_path)

    data = JSON.parse(File.read(file_path))
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
