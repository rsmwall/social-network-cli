# frozen_string_literal: true

# class Profiles Repository
class ProfileRepo
  def initialize(profiles)
    @profiles = profiles
  end

  def add(profile)
    @profiles << profile
  end
end
