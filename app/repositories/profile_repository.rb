# frozen_string_literal: true

require '../models/profile.rb'

# class Profile Repository
class ProfileRepository
  def initialize
    @profiles = {}
  end

  def add(profile)
    return if @profiles.key?(profile.id)

    @profiles[profile.id] = profile
  end

  def search(params)
    params = params.reject { |_, value| value.nil? }

    profile = nil
    @profiles.each do |key, value|
      if params.all? { |param_key, param_value| value.send(param_key) == param_value }
        profile = value
        break
      end
    end

    profile
  end
end