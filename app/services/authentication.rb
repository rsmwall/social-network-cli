# frozen_string_literal: true

require 'bcrypt'

# class Authentication
class Authentication
  attr_reader :current_user

  def initialize(profile_repository)
    @profile_repository = profile_repository
    @current_user = nil
  end

  def login(user, password)
    profile = @profile_repository.search_to_add(user: user)
    return false unless profile && BCrypt::Password.new(profile.password) == password

    @current_user = profile
    true
  end

  def logout
    return false unless @current_user

    @current_user = nil
    true
  end

  def logged_in?
    !@current_user.nil?
  end
end
