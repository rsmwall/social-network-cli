# frozen_string_literal: true

# class Feed Controller
class FeedController
  def post_profile(profile, profile_posts, posts)
    unless profile.nil?
      profile_posts.each do |post|
        if !post.instance_of?(AdvancedPost) then posts << post
        elsif post.remaining_views.positive?
          decrement_views(post.id)
          posts << post
        end
      end
    end
    posts
  end

  def post_by_hashtag(hashtag, post_repository)
    posts = []
    post_repository.posts.each_value do |post|
      if post.instance_of?(AdvancedPost) && post.hashtag?(hashtag) && post.remaining_views.positive?
        posts << post
        decrement_views(post.id)
      end
    end
    posts
  end
end
