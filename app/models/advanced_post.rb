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
end
