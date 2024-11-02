# frozen_string_literal: true

# class Profile
class Profile
  attr_reader :id, :user, :email

  def initialize(id, user, email)
    @id = id
    @user = user
    @email = email
  end
end