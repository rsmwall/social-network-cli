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
    post&.like
  end

  def dislike(id)
    post = search_post(id: id)
    post&.dislike
  end
end
