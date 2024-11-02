# frozen_string_literal: true

# class Profile
class Profile
  attr_reader :id, :user, :email, :posts

  def initialize(params)
    @id = params[:id]
    @user = params[:user]
    @email = params[:email]
    @posts = []
  end
end
