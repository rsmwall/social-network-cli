# frozen_string_literal: true

require_relative 'post'

# class Profile
class Profile
  attr_accessor :posts, :followers, :following
  attr_reader :id, :name, :user, :email, :password, :desc

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @user = params[:user]
    @email = params[:email]
    @password = params[:password]
    @desc = params[:desc]
    @posts = []
    @followers = []
    @following = []
  end

  def customization(name, desc)
    @name = name
    @desc = desc
  end

  def add(post_id)
    @posts << post_id
  end

  def to_h
    {
      id: @id,
      name: @name,
      user: @user,
      email: @email,
      password: @password,
      desc: @desc,
      followers: @followers,
      following: @following
    }
  end

  def self.from_h(hash)
    Profile.new(
      id: hash['id'],
      name: hash['name'],
      user: hash['user'],
      email: hash['email'],
      password: hash['password'],
      desc: hash['desc'],
      followers: hash['followers'],
      following: hash['following']
    )
  end
end
