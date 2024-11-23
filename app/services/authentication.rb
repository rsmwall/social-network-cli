# frozen_string_literal: true

require 'bcrypt'
require_relative '../repositories/profile_repository'

# class Authentication
class Authentication
  def initialize(profile_repo)
    @profile_repo = profile_repo
    @current_user = nil
  end
end