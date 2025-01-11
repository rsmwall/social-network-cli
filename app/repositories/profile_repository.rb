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
    profile = Profile.new(
      id: @next_id, name: params[:name], user: params[:user], 
      email: params[:email], password: params[:password], desc: params[:desc]
    )
    @next_id += 1
    @profiles[profile.id] = profile
  end

  def search_to_add(params)
    params = params.reject { |_, value| value.nil? }

    profile = nil
    @profiles.each do |_, value|
      if params[:user] == value.user || params[:email] == value.email
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

    profiles_result
  end

  # persistence

  def save
    data = @profiles.map { |_, value| value.to_h }
    Dir.mkdir('app/data') unless Dir.exist?('app/data')
    File.new('app/data/profiles.json', 'a')
    File.write('app/data/profiles.json', JSON.pretty_generate(data))
  end

  def load
    return unless File.exist?('app/data/profiles.json')

    data = JSON.parse(File.read('app/data/profiles.json'))
    data.each do |profile_hash|
      profile = Profile.from_h(profile_hash)
      @profiles[profile.id] = profile
      @next_id = [@next_id, profile.id + 1].max
    end
  end
end