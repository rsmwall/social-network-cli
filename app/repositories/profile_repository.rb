# frozen_string_literal: true

# class Profiles Repository
class ProfileRepo
  def initialize(profiles)
    @profiles = profiles
  end

  def add(profile)
    @profiles << profile
  end

  def search(id, user, email)
    @profiles.each do |profile|
      return profile if profile.id.eql?(id) || profile.user.eql?(user) || profile.email.eql?(email)
    end

    nil
  end
end
