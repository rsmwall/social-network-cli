# frozen_string_literal: true

require_relative 'post'

# class Profile
class Profile
  attr_accessor :posts
  attr_reader :id, :user, :email, :password

  def initialize(params)
    @id = params[:id]
    @user = params[:user]
    @email = params[:email]
    @posts = []
    @password = params[:email]
  end

  def add(post_id)
    @posts << post_id
  end
end
