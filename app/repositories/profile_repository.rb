# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative '../models/profile'

# class Profile Repository
class ProfileRepository
  attr_reader :profiles
  
  def initialize
    @profiles = {}
    @next_id = 1
  end

  def add(params)
    profile = Profile.new(id: @next_id, user: params[:user], email: params[:email], password: params[:password])
    @next_id += 1
    @profiles[profile.id] = profile
  end

  def search_to_add(params)
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

  def search(user)
    profiles_result = []

    @profiles.each do |_, profile|
      profiles_result << profile if profile.user.include?(user)
    end
  end

  # persistence

  def save
    data = @profiles.map { |_, value| value.to_h }
    File.new('profiles.json', 'a')
    File.write('profiles.json', JSON.pretty_generate(data))
  end

  def load(file_path)
    return unless File.exist?(file_path)

    data = JSON.parse(File.read(file_path))
    data.each do |profile_hash|
      profile = Profile.from_h(profile_hash)
      @profiles[profile.id] = profile
      @next_id = [@next_id, profile.id + 1].max
    end
  end
end