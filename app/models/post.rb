# frozen_string_literal: true

# class Post
class Post
  attr_reader :id, :text, :likes, :dislikes, :date, :profile

  def initialize(params)
    @id = params[:id]
    @text = params[:text]
    @likes = params[:likes]
    @dislikes = params[:dislikes]
    @date = params[:date]
    @profile = params[:profile]
  end

  def like
    @likes += 1
  end

  def dislike
    @dislikes += 1
  end

  def to_h
    {
      id: @id,
      text: @text,
      likes: @likes,
      dislikes: @dislikes,
      date: @date,
      profile_id: @profile.id
    }
  end

  def self.from_h(hash, profile)
    Post.new(
      id: hash['id'],
      text: hash['text'],
      likes: hash['likes'],
      dislikes: hash['dislikes'],
      date: hash['date'],
      profile: profile
    )
  end
end
