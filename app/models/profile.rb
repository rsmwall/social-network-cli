# frozen_string_literal: true

# class Profile
class Profile
  attr_reader :id, :user, :email, :posts

  def initialize(id, user, email, posts)
    @id = id
    @user = user
    @email = email
    @posts = posts
  end
end
