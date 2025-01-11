# frozen_string_literal: true

require 'bcrypt'
require 'tty-prompt'
require_relative './app/services/social_network'
require_relative './app/services/authentication'

# class App
class App
  def initialize
    @prompt = TTY::Prompt.new
    @social_network = SocialNetwork.new
    @social_network.load_data
    @auth_service = Authentication.new(@social_network.profile_repo)
  end

  # auth methods

  def login_menu
    Gem.win_platform? ? system('cls') : system('clear')

    @prompt.select('') do |it|
      it.choice 'Login', -> { login }
      it.choice 'Sign-Up', -> { signup }
      it.choice 'Exit', lambda {
        @social_network.save_data
        Gem.win_platform? ? system('cls') : system('clear')
        @prompt.ok('Exiting...')
        abort
      }
    end
  end

  def login
    Gem.win_platform? ? system('cls') : system('clear')

    login_info = @prompt.collect do
      key(:user).ask('User:')
      key(:password).mask('Password:')
    end

    menu if @auth_service.login(login_info[:user], login_info[:password])
    login
  end

  def customization(user)
    profile = @social_network.search_profile(user, 2)

    name = @prompt.ask('Name:', default: user)
    desc = @prompt.multiline('Description:', default: "This is a description.")

    profile.customization(name, desc)
  end

  def signup
    Gem.win_platform? ? system('cls') : system('clear')

    user = @prompt.ask('User:', required: true)
    email = @prompt.ask('Email:', required: true) do |q|
      q.validate(/\A\w+@\w+\.\w+\Z/, 'Invalid email address!')
    end

    password = @prompt.ask('Password:', required: true)
    @prompt.ask('Repeat Password:', required: true) do |q| 
      q.validate -> (input) { input == password }
      q.messages[:valid?] = 'Passwords do not match!'
    end

    if @social_network.add_profile(
        user: user, email: email, password: BCrypt::Password.create(password)
      )
      @prompt.ok("\nProfile added successfully!\n")
      customization(user)
    else
      @prompt.error("\nUser or email is already in use!")
    end
    
    @prompt.keypress("\nPress Enter to return to menu...", keys: [:return])
    login_menu
  end

  def logout
    login_menu if @auth_service.logout
    menu
  end

  # general methods

  def menu
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\nWelcome, #{@auth_service.current_user.name}!\n\n"
    
    @prompt.select('') do |it|
      it.choice 'Feed', -> { feed }
      it.choice 'Search', -> { search }
      it.choice 'Add Post', -> { add_post }
      it.choice 'Profile', -> { profile }
      it.choice 'Logout', -> { logout }
    end
  end

  def enter_key
    puts "\nPress Enter to return to the menu..."
    key = gets
    menu if key == "\n"
  end

  def search
    system('clear')
    puts "\n❖ Search\n"
    print "\nEnter your search query:\n- Start with '@' to search for a profile.\n- Start with '#' to search for a hashtag.\n- Type plain text to search for posts.\n> "

    term = gets.chomp

    search_profile(term[1..-1]) if term.start_with?('@')
    search_hashtag(term[1..-1]) if term.start_with?('#')
    search_post(term)
  end

  # profile methods

  def profile
    Gem.win_platform? ? system('cls') : system('clear')
    profile = @auth_service.current_user

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
        puts "-" * 40
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
          hashtags: hashtags, remaining_views: 100)
        break
      elsif option == 'n'
        success = @social_network.add_post(
          text: text, likes: 0, dislikes: 0, date: Time.now, profile: @auth_service.current_user)
        break
      end
    end

    puts success ? "\n\nPost added successfully!" : "\n\nError creating post!"
    enter_key
  end

  def print_posts(posts)
    posts.each do |post|
      post_print = "\nid:#{post.id} \e[1m@#{post.profile.user}\e[0m\n#{post.text}\n#{post.date}"
      post_print << "\n\n" + post.hashtags.map { |hashtag| "\e[34m##{hashtag}\e[0m" }.join(" ") if post.instance_of?(AdvancedPost)
      puts "#{post_print}\n\n▲ #{post.likes}  ▼ #{post.dislikes}"
      puts "-" * 40
    end

    enter_key
  end

  def feed
    posts = @social_network.post_repo.posts.values
    puts "There are no posts yet, be the first :)" unless !posts.empty?
    print_posts(posts)
    enter_key
  end

  def search_post(text)
    result = @social_network.search_post(text: text)

    print_posts(result) if !result.empty?

    puts "\nNo post found."
    enter_key
  end

  def search_hashtag(hashtag)
    result = @social_network.show_post_by_hashtag(hashtag)

    print_posts(result) if !result.empty?
      
    puts "\nNo post found with this hashtag."
    enter_key
  end
end

app = App.new
app.login_menu