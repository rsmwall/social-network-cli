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
end
