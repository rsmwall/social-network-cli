# frozen_string_literal: true

require 'tty-prompt'

# class Feed View
class FeedView
  def initialize(social_network, post_view, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
    @post_view = post_view
    @app = app
  end

  def feed
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Feed\n\n"
    posts = @social_network.post_repository.posts.values
    @post_view.print_posts(posts) unless posts.empty?

    @prompt.say('There are no posts yet, be the first :)')
    
    @prompt.keypress("\nPress Enter to return to feed...", keys: [:return])
    feed
  end
end