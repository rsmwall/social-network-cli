# frozen_string_literal: true

require '../models/profile'

# class Profile Repository
class ProfileRepository
  attr_reader :profiles
  def initialize
    @profiles = {}
  end

  def add(params)
    profile = Profile.new(id: params[:id], user: params[:user], email: params[:email])
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