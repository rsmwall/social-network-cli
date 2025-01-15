# frozen_string_literal: true

require 'tty-prompt'

# class Search View
class SearchView
  def initialize(social_network, profile_view, post_view, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
    @profile_view = profile_view
    @post_view = post_view
    @app = app
  end

  def search
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Search\n\n"
    puts 'Hint: @ to users, # to hashtags, plain text to posts'
    search_text = @prompt.ask('> ', required: true)

    search_profile(search_text[1..]) if search_text.start_with?('@')
    search_hashtag(search_text[1..]) if search_text.start_with?('#')
    search_post(search_text)
  end

  def search_profile(user)
    profiles = @social_network.search_profile(user, 1)
    @profile_view.print_profiles(profiles) unless profiles.empty?

    @prompt.say("\nNo profile found with the given criteria.")

    @prompt.keypress("\nPress Enter to return to menu.", keys: [:return])
    @app.main_menu
  end

  def search_hashtag(hashtag)
    posts = @social_network.show_post_by_hashtag(hashtag)
    @post_view.print_posts(posts) unless posts.empty?

    @prompt.say("\nNo post found with this hashtag.")

    @prompt.keypress("\nPress Enter to return to menu.", keys: [:return])
    @app.main_menu
  end

  def search_post(text)
    posts = @social_network.search_post(text: text)
    @post_view.print_posts(posts) unless posts.empty?

    @prompt.say("\nNo post found.")

    @prompt.keypress("\nPress Enter to return to menu.", keys: [:return])
    @app.main_menu
  end
end
