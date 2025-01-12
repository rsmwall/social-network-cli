#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bcrypt'
require 'tty-prompt'
require 'time'
require_relative './app/services/social_network'
require_relative './app/services/authentication'
require_relative './app/views/authentication_view'

# TODO: separate App class

# class App
class App
  def initialize
    @prompt = TTY::Prompt.new
    @social_network = SocialNetwork.new
    @social_network.load_data
    @auth_service = Authentication.new(@social_network.profile_repository)

    @auth_view = AuthenticationView.new(@social_network, @auth_service, @prompt, self)
  end

  # auth methods

  def run
    @auth_view.initial_menu
  end

  def exit
    @social_network.save_data
    Gem.win_platform? ? system('cls') : system('clear')
    @prompt.ok('Exiting...')
    sleep(2)
    abort
  end

  def customization(user)
    profile = @social_network.search_profile(user, 2)

    name = @prompt.ask('Name:', default: user)
    desc = @prompt.multiline('Description:', default: 'This is a description.')

    profile.customization(name, desc)
  end

  # general methods

  def main_menu
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\nWelcome, #{@auth_service.current_user.name}!\n\n"

    @prompt.select('') do |it|
      it.choice 'Feed', -> { feed }
      it.choice 'Search', -> { search }
      it.choice 'Add Post', -> { add_post }
      it.choice 'Profile', -> { profile(@auth_service.current_user) }
      it.choice 'Logout', -> { @auth_view.logout }
    end
  end

  # TODO: update search

  def search
    system('clear')
    puts "\n❖ Search\n"
    print "\nEnter your search query:\n- Start with '@' to search for a profile.\n- Start with '#' to search for a hashtag.\n- Type plain text to search for posts.\n> "

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

  # posts methods

  def add_post
    system('clear')
    puts "\n❖ Add Post\n"
    print "\nEnter Text\n> "
    text = gets.chomp

    success = nil
    loop do
      print "\nAdd hahstags (y/n): "
      option = gets.chomp.downcase

      if option == 'y'
        print "\nEnter hashtags (separated by commas)\n> "
        input = gets.chomp
        hashtags = input.split(',').map(&:strip)

        success = @social_network.add_post(
          text: text, likes: 0, dislikes: 0, date: Time.now, profile: @auth_service.current_user,
          hashtags: hashtags, remaining_views: 100
        )
        break
      elsif option == 'n'
        success = @social_network.add_post(
          text: text, likes: 0, dislikes: 0, date: Time.now, profile: @auth_service.current_user
        )
        break
      end
    end

    puts success ? "\n\nPost added successfully!" : "\n\nError creating post!"
    enter_key
  end

  def post_preview(post)
    time = Time.parse(post.date)
    formatted_time = time.strftime('%b %d, %Y, %-I:%M %p')
    "#{post.profile.name} @#{post.profile.user} - #{formatted_time} - ▲ #{post.likes}  ▼ #{post.dislikes}"
  end

  def format_post(post)
    time = Time.parse(post.date)
    formatted_time = time.strftime('%b %d, %Y, %-I:%M %p')

    post_print = "\n\e[1m#{post.profile.name}\e[0m @#{post.profile.user}\n\n#{post.text}"
    if post.instance_of?(AdvancedPost)
      post_print << "\n#{post.hashtags.map { |hashtag| "\e[34m##{hashtag}\e[0m" }.join(' ')}"
    end
    post_print << "\n\n#{formatted_time}\n\n▲ #{post.likes}  ▼ #{post.dislikes}\n\n"
    post_print
  end

  def print_posts(posts)
    choices = posts.map { |post| { name: post_preview(post), value: post } }
    choices << 'Exit'
    selected_post = @prompt.select('Feed', choices)
    menu if selected_post == 'Exit'

    Gem.win_platform? ? system('cls') : system('clear')
    puts format_post(selected_post)

    @prompt.select('') do |it|
      it.choice 'Like', -> { selected_post.like }
      it.choice 'Dislike', -> { selected_post.dislike }
      it.choice 'Exit', -> { feed }
    end
  end

  def feed
    Gem.win_platform? ? system('cls') : system('clear')
    posts = @social_network.post_repository.posts.values
    puts 'There are no posts yet, be the first :)' if posts.empty?
    print_posts(posts)
    @prompt.keypress("\nPress Enter to return to menu...", keys: [:return])
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
