# frozen_string_literal: true

require 'bcrypt'
require_relative '../repositories/profile_repository'

# class Authentication
class Authentication
  attr_reader :current_user

  def initialize(profile_repo)
    @profile_repo = profile_repo
    @current_user = nil
  end

  def login(user, password)
    profile = @profile_repo.search_to_add(user)
    if profile && BCrypt::Password.new(profile[:password]) == password
      @current_user = profile
      puts "\nLogin successful! Welcome, #{profile.user}."
      sleep(2)
      true
    else
      puts "\nIncorrect username or password!"
      sleep(2)
      false
    end
  end

  def logout
    if @current_user
      puts "\nLogout successful!"
      @current_user = nil
      sleep(2)
      true
    else
      puts "\nNo user logged in!"
      sleep(2)
      false
    end
  end

  def logged_in?
    !@current_user.nil?
  end
end