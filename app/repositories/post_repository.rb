# frozen_string_literal: true

require_relative '../models/post'
require_relative '../models/advanced_post'
require_relative '../models/profile'

# class Post Repository
class PostRepository
  def initialize
    @posts = {}
    @next_id = 1
  end

  def add(params)
    params_full = {id: @netx_id}.merge(params)
    if params.key?(:hashtags)
      post = AdvancedPost.new(params_full, params[:hashtags], params[:remaining_views])
    else
      post = Post.new(params_full)
    end

    @next_id += 1
    @posts[post.id] = post
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

  def show_posts
    @posts
  end
end
