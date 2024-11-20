# frozen_string_literal: true

require_relative 'post'

# class Profile
class Profile
  attr_reader :id, :user, :email

  def initialize(params)
    @id = params[:id]
    @user = params[:user]
    @email = params[:email]
  end
end
