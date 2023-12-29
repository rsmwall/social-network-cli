# frozen_string_literal: true

require '../models/profile'
require '../models/post'
require '../models/advanced_post'

# class Posts Repository
class PostRepo
  attr_reader :posts

  def initialize(posts)
    @posts = posts
  end

  def add(post)
    @posts << post
    post.profile
  end

  def search(id, text, date, profile, hashtag)
    posts = []
    @posts.each do |post|
      if advanced_post?(post, hashtag) || post.id == (id) || post_text(post, text) ||
         post.date == (date) || post.profile == (profile)
        posts << post
      end
    end

    posts
  end

  def post_text(post, text)
    !text.empty? # && post.text.include?(text)
  end

  def advanced_post?(post, hashtag)
    post.hashtag?(hashtag) if post.is_a?(AdvancedPost)
  end
end

pr = Profile.new(1, 'Rafael', 'rafael@gmail.com', [])

posth = {
  id: 1,
  text: 'olamundo',
  like: 2,
  dislike: 0,
  date: '2023-12-28',
  perfil: pr
}

posth1 = {
  id: 2,
  text: 'olamundo',
  like: 2,
  dislike: 0,
  date: '2023-12-28',
  perfil: pr
}

post = Post.new(posth)
posta = AdvancedPost.new(posth1, ['ola'], 200)
repo_post = PostRepo.new([])
repo_post.add(post)
repo_post.add(posta)
puts repo_post.search(nil, '', nil, nil, nil)
