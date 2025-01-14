#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bcrypt'
require 'tty-prompt'
require 'time'
require_relative './app/services/social_network'
require_relative './app/services/authentication'
require_relative './app/views/authentication_view'
require_relative './app/views/post_view'

# TODO: separate App class

# class App
class App
  def initialize
    @prompt = TTY::Prompt.new
    @social_network = SocialNetwork.new
    @social_network.load_data
    @auth_service = Authentication.new(@social_network.profile_repository)

    @post_view = PostView.new(@social_network, @prompt, self)
    @auth_view = AuthenticationView.new(@social_network, @auth_service, @prompt, @post_view, self)
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

    puts "\n❖ Welcome, #{@auth_service.current_user.name}!\n\n"

    @prompt.select('', show_help: :always, cycle: true) do |it|
      it.choice 'Feed', -> { feed }
      it.choice 'Search', -> { search }
      it.choice 'Create Post', -> { @post_view.create }
      it.choice 'Profile', -> { profile(@auth_service.current_user) }
      it.choice 'Logout', -> { @auth_view.logout }
    end
  end

  def customization(user)
    profile = @social_network.search_profile(user, 2)

    name = @prompt.ask('Name:', default: user)
    desc = @prompt.multiline('Description:', default: 'This is a description.')

    profile.customization(name, desc)
  end

  # TODO: update search

  def search
    system('clear')
    puts "\n❖ Search\n"
    search_text <<-TEXT
    Enter your search query:
    - Start with '@' to search for a profile.
    - Start with '#' to search for a hashtag.
    - Type plain text to search for posts
    TEXT

    term = gets.chomp

    search_profile(term[1..]) if term.start_with?('@')
    search_hashtag(term[1..]) if term.start_with?('#')
    search_post(term)
  end

  # profile methods

  def profile(profile)
    Gem.win_platform? ? system('cls') : system('clear')
    puts "\n❖ Profile\n"
    puts "\e[1m#{profile.name}\e[0m"
    puts "@#{profile.user}\n\n"
    puts "0 followers  0 following  #{profile.posts.length} posts\n\n"
    puts profile.desc
    @prompt.keypress("\nPress Enter to return to menu...", keys: [:return])
    menu
  end

  def search_profile(user)
    result = @social_network.search_profile(user, 1)

    if !result.empty?
      result.each do |profile|
        puts "\nUSER > @#{profile.user}\nE-MAIL > #{profile.email}"
        puts '-' * 40
      end
    else
      puts "\nNo profile found with the given criteria."
    end

    enter_key
  end

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
