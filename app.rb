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
require_relative './app/views/feed_view'

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
    @profile_view = ProfileView.new(@social_network, @post_view, self)
    @auth_view = AuthenticationView.new(@social_network, @auth_service, @post_view, @profile_view, self)
    @search_view = SearchView.new(@social_network, @profile_view, @post_view, self)
    @feed_view = FeedView.new(@social_network, @post_view, self)
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

    @prompt.select('', show_help: :always, cycle: true) do |menu|
      menu_options(menu)
    end
  end

  def menu_options(menu)
    menu.choice 'Feed', -> { feed }
    menu.choice 'Search', -> { @search_view.search }
    menu.choice 'Create Post', -> { @post_view.create(@current_user) }
    menu.choice 'Profile', -> { @profile_view.profile(@current_user) }
    menu.choice 'Logout', -> { @auth_view.logout }
  end

  def feed
    @feed_view.feed
  end
end

App.new.run
