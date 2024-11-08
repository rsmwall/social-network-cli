# frozen_string_literal: true

require_relative 'post'

# class Profile
class Profile
  attr_accessor :posts
  attr_reader :id, :user, :email, :posts

  def initialize(params)
    @id = params[:id]
    @user = params[:user]
    @email = params[:email]
    @posts = []
  end

  def add(post)
    @posts << post
  end
end
