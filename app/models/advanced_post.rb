# frozen_string_literal: true

require_relative 'post'

# class Advanced Post
class AdvancedPost < Post
  attr_reader :hashtags, :remaining_views

  def initialize(params, hashtags, remaining_views)
    super(params)
    @hashtags = hashtags
    @remaining_views = remaining_views
  end

  def add_hashtag(hashtag)
    @hashtags << hashtag
  end

  def has_hashtag?(hashtag)
    @hashtags.include?(hashtag)
  end

  def decrement_views
    @remaining_views -= 1 if @remaining_views > 0
  end

  def to_h
    super.merge(
      hashtags: @hashtags,
      remaining_views: @remaining_views
    )
  end

  def self.from_h(hash, profile)
    AdvancedPost.new(
      id: hash['id'],
      text: hash['text'],
      likes: hash['likes'],
      dislikes: hash['dislikes'],
      date: hash['date'],
      profile: profile,
      hashtags: hash['hashtags'],
      remaining_views: hash['remaining_views']
    )
  end
end