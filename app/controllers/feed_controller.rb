# frozen_string_literal: true

# class Feed Controller
class FeedController
  def post_profile(profile, profile_posts, posts)
    profile_posts.each { |post| posts << post } unless profile.nil?

    posts
  end

  def post_by_hashtag(hashtag, post_repository)
    posts = []
    post_repository.posts.each_value do |post|
      if post.instance_of?(AdvancedPost) && post.hashtag?(hashtag)
        posts << post
      end
    end
    posts
  end
end
