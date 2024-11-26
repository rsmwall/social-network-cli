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
    @password = params[:password]
    @posts = []
  end

  def add(post_id)
    @posts << post_id
  end

  def to_h
    {
      id: @id,
      user: @user,
      email: @email,
      password: @password
    }
  end

  def self.from_h(hash)
    Profile.new(
      id: hash['id'], user: hash['user'], email: hash['email'], password: hash['password']
    )
  end
end
