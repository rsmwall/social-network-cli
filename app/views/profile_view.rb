# frozen_string_literal: true

require 'tty-prompt'

# class Profile View
class ProfileView
  def initialize(social_network, post_view, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
    @post_view = post_view
    @app = app
  end

  def customization(user)
    profile = @social_network.search_profile(user, 2)

    name = @prompt.ask('Name:', default: user)
    desc = @prompt.multiline('Description:', default: 'This is a description.')

    profile.customization(name, desc)
  end

  def print_profiles(profiles)
    choices = profiles.map { |profile| { name: profile_preview(profile), value: profile } }
    choices << 'Back to menu'
    puts ''
    selected_profile = @prompt.select('', choices, show_help: :always, cycle: true, per_page: 50)
    @app.main_menu if selected_profile == 'Back to menu'

    Gem.win_platform? ? system('cls') : system('clear')
    puts format_profile(selected_profile)

    profile_actions(selected_profile)
  end

  def profile(profile)
    Gem.win_platform? ? system('cls') : system('clear')
    puts format_profile(profile)

    profile_actions(profile)
  end

  def profile_preview(profile)
    "#{profile.name} (@#{profile.user}) - #{profile.posts.length} posts"
  end

  def format_profile(profile)
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Profile\n\n"
    print_profile = "#{profile.name}\n@#{profile.user}\n\n"
    print_profile << "#{profile.followers.length} followers  #{profile.following.length} following"
    print_profile << "  #{profile.posts.length} posts\n\n"
    print_profile << "#{profile.desc}\n\n"

    print_profile
  end

  def profile_actions(profile)
    choices = [
      follow_verification(profile),
      { name: "#{profile.user}'s posts", value: -> { profile_posts(profile.user) } },
      { name: 'Back to menu', value: -> { @app.main_menu } }
    ]

    @prompt.select('', choices, show_help: :always, cycle: true) if profile != @app.current_user
    @prompt.select('', choices[1..], show_help: :always)
  end

  def profile_posts(user)
    posts = @social_network.show_post_profile(user)
    @post_view.print_posts(posts) unless posts.empty?

    @prompt.say("\nNo posts yet.")

    @prompt.keypress("\nPress Enter to return to menu.", keys: [:return])
    @app.main_menu
  end

  private

  def follow_verification(profile)
    if @social_network.following?(@app.current_user, profile)
      { name: 'Unfollow', value: -> { @social_network.unfollow(@app.current_user, profile) } }
    else
      { name: 'Follow', value: -> { @social_network.follow(@app.current_user, profile) } }
    end
  end
end
