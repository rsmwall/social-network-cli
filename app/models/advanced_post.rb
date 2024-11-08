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
end