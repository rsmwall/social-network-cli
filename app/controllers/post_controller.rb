# frozen_string_literal: true

# class Post Controller
class PostController
  def add(params, post_repository)
    return false if params.any? { |_, value| value.nil? }
    
    post_repository.add(params)
    true
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
end