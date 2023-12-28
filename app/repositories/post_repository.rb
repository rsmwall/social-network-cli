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
end
