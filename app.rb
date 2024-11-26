# frozen_string_literal: true

require 'bcrypt'
require_relative './app/services/social_network'
require_relative './app/services/authentication'

# class App
class App
  def initialize
    @social_network = SocialNetwork.new
    @social_network.load_data
    @auth_service = Authentication.new(@social_network.profile_repo)
    @menu = <<~MENU
    1. Search  2. Add Post         
    0. Logout
    MENU
  end

  # auth methods
  
  def login_menu
    loop do
      system('clear')
      puts "\n❖ RafaBook\n\n"
      print "1. Login   2. Sign-Up\n0. Exit\n"
      print "\nEnter an option\n> "
      option = gets.chomp.to_i

      if option.zero?
        @social_network.save_data
        puts "\nExiting..."
        break
      else
        case option
        when 1 then login
        when 2 then signup
        end
      end
    end
  end

  def login
    system('clear')
    puts "\n❖ Login\n"
    print "\nUsername\n> "
    user = gets.chomp
    print "\nPassword\n> "
    password = gets.chomp

    menu if @auth_service.login(user, password)
    login
  end

  def logout
    login_menu if @auth_service.logout
    menu
  end

  # general methods

  def menu
    loop do
      system('clear')
      puts "\n❖ RafaBook\n\n"
      puts @menu
      print "\nEnter an option\n> "
      option = gets.chomp.to_i

      break if option.zero?

      menu_action(option)
    end

    logout
  end

  def menu_action(option)
    case option
    when 1 then search
    when 2 then add_post
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

  def signup
    system('clear')
    puts "\n❖ Sign-Up\n"
    print "\nUsername\n> "
    user = gets.chomp
    print "\nE-mail\n> "
    email = gets.chomp
    print "\nPassword\n> "
    password = gets.chomp

    success = @social_network.add_profile(
      user: user, email: email, password: BCrypt::Password.create(password))
    puts success ? "\n\nProfile added successfully!" : "\n\nError adding profile!"
    
    puts "\nPress Enter to return to the menu..."
    key = gets
    login_menu if key == "\n"
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
      post_print = "\nid:#{post.id} @#{post.profile.user}\n#{post.text}\n#{post.date}"
      post_print << "\n\n" + post.hashtags.map { |hashtag| "##{hashtag}" }.join(" ") if post.instance_of?(AdvancedPost)
      puts "#{post_print}\n\n▲ #{post.likes}  ▼ #{post.dislikes}"
      puts "-" * 40
    end

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