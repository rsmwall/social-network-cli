# frozen_string_literal: true

require '../models/profile'

# class Posts Repository
class PostRepo
  def initialize(posts)
    @posts = posts
  end

  def add(post)
    @posts << post
    post.profile.posts << post
  end

  def search(id, text, date, profile, hashtag)
    @posts.each do |post|
      if advanced_post?(post, hashtag)
        return post
      elsif post.id.eql?(id) || post.text.include?(text) || post.date.eql?(date) || post.profile.eql?(profile)
        return post
      end
    end
  end

  def advanced_post?(post, hashtag)
    post.hashtags.hashtag?(hashtag) if post.is_a?(AdvancedPost)
  end
end
