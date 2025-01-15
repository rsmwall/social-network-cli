# frozen_string_literal: true

require 'tty-prompt'

# class Search View
class SearchView
  def initialize(social_network, profile_view, prompt, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
    @profile_view = profile_view
    @prompt = prompt
    @app = app
  end

  def search
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Search\n\n"
    puts 'Hint: @ to users, # to hashtags, plain text to posts'
    search_text = @prompt.ask('> ', required: true)

    search_profile(search_text[1..]) if search_text.start_with?('@')
    search_hashtag(term[1..]) if term.start_with?('#')
    search_post(term)
  end

  def search_profile(user)
    profiles = @social_network.search_profile(user, 1)
    if !profiles.empty?
      @profile_view.print_profiles(profiles)
    else
      @prompt.say("\nNo profile found with the given criteria.")
    end

    @prompt.keypress("\nPress Enter to return to menu.", keys: [:return])
    @app.main_menu
  end
end
