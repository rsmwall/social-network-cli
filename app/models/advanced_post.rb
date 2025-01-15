# frozen_string_literal: true

require_relative 'post'

# class Advanced Post
class AdvancedPost < Post
  attr_reader :hashtags

  def initialize(params, hashtags)
    super(params)
    @hashtags = hashtags
  end

  def add_hashtag(hashtag)
    @hashtags << hashtag
  end

  def hashtag?(hashtag)
    @hashtags.include?(hashtag)
  end

  def to_h
    super.merge(
      hashtags: @hashtags
    )
  end

  def self.from_h(hash, profile)
    AdvancedPost.new(
      { id: hash['id'],
        text: hash['text'],
        likes: hash['likes'],
        dislikes: hash['dislikes'],
        date: hash['date'],
        profile: profile },
      hash['hashtags']
    )
  end
end
