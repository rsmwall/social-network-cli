# frozen_string_literal: true

require_relative '../models/post'
require_relative '../models/advanced_post'
require_relative '../models/profile'

# class Post Repository
class PostRepository
  def initialize
    @posts = {}
  end

  def add(params)
    if params.key?(:hashtags)
      post = AdvancedPost.new(params, params[:hashtags],params[:remaining_views])
    else
      post = Post.new(params)
    end

    @posts[post.id] = post
    params[:profile].add(post) if params[:profile]
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
end
