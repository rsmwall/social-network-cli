#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bcrypt'
require 'tty-prompt'
require 'time'
require_relative './app/services/social_network'
require_relative './app/services/authentication'
require_relative './app/views/authentication_view'
require_relative './app/views/post_view'
require_relative './app/views/search_view'
require_relative './app/views/profile_view'

# TODO: separate App class

# class App
class App
  attr_accessor :current_user

  def initialize
    @prompt = TTY::Prompt.new
    @social_network = SocialNetwork.new
    @social_network.load_data
    @auth_service = Authentication.new(@social_network.profile_repository)
    @current_user = nil

    @post_view = PostView.new(@social_network, self)
    @profile_view = ProfileView.new(@social_network, @prompt, self)
    @auth_view = AuthenticationView.new(@social_network, @auth_service, @post_view, @profile_view, self)
    @search_view = SearchView.new(@social_network, @profile_view, @prompt, self)
  end

  def run
    @auth_view.initial_menu
  end

  def exit
    @social_network.save_data
    Gem.win_platform? ? system('cls') : system('clear')
    @prompt.ok('Exiting...')
    sleep(2)

    Gem.win_platform? ? system('cls') : system('clear')
    abort
  end

  def main_menu
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Welcome, #{@current_user.name}!\n\n"

    @prompt.select('', show_help: :always, cycle: true) do |it|
      it.choice 'Feed', -> { feed }
      it.choice 'Search', -> { @search_view.search }
      it.choice 'Create Post', -> { @post_view.create(@current_user) }
      it.choice 'Profile', -> { @profile_view.profile(@current_user) }
      it.choice 'Logout', -> { @auth_view.logout }
    end
  end

  # TODO: update search

  def feed
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Feed\n\n"
    posts = @social_network.post_repository.posts.values
    @prompt.say('There are no posts yet, be the first :)') if posts.empty?
    @post_view.print_posts(posts)
    @prompt.keypress("\nPress Enter to return to feed...", keys: [:return])
    feed
  end

  def search_post(text)
    result = @social_network.search_post(text: text)

    print_posts(result) unless result.empty?

    puts "\nNo post found."
    enter_key
  end

  def search_hashtag(hashtag)
    result = @social_network.show_post_by_hashtag(hashtag)

    print_posts(result) unless result.empty?

    puts "\nNo post found with this hashtag."
    enter_key
  end
end

App.new.run
