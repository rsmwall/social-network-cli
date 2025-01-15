# frozen_string_literal: true

require 'tty-prompt'

# class Profile View
class ProfileView
  def initialize(social_network, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
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
    print_profile << "0 followers  0 following  #{profile.posts.length} posts\n\n"
    print_profile << "#{profile.desc}\n\n"

    print_profile
  end

  def profile_actions(profile)
    choices = [
      { name: 'Follow', value: 1, disabled: 'soon' },
      { name: 'Unfollow', value: 2, disabled: 'soon' },
      { name: "#{profile.user}'s posts", value: 3, disabled: 'soon' },
      { name: 'Back to menu', value: -> { @app.main_menu } }
    ]
    @prompt.select('', choices, show_help: :always, cycle: true) if profile != @app.current_user
    @prompt.select('', choices[2..], show_help: :always)
  end
end
