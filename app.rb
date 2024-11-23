# frozen_string_literal: true

require 'bcrypt'
require_relative './app/services/social_network.rb'

# class App
class App
  def initialize
    @social_network = SocialNetwork.new
    @menu = <<~MENU
    1. Add Profile  2. Search
    3. Add Post          
    0. Exit
    MENU
  end

  def menu
    system('clear')
    puts "\n❖ RafaBook\n\n"
    puts @menu
    print "\nEnter an option\n> "
    option = gets.chomp.to_i

    menu_action(option)
  end

  def menu_action(option)
    case option
    when 1 then add_profile
    when 2 then search
    when 3 then add_post
    end
  end

  def enter_key
    puts "\nPress Enter to return to the menu..."
    key = gets
    menu if key == "\n"
  end

  def search
    puts "\n❖ Search\n\n"
    print "\nType something starting with: @ to search for a profile,\n# for a hashtag or just the text to search posts\n> "
    term = gets.chomp

    search_profile(term[1..-1]) if term.start_with?('@')
    search_hashtag(term[1..-1]) if term.start_with?('#')
    search_post(term)
  end

  # profile methods

  def add_profile
    puts "\n❖ Add Profile\n\n"
    print "\nEnter User\n> "
    user = gets.chomp
    print "\nEnter E-mail\n> "
    email = gets.chomp
    print "\nPassword\n> "
    password = gets.chomp

    hashed_password = BCrypt::Password.create(password)
    success = @social_network.add_profile(user: user, email: email, password: hashed_password)
    puts success ? "\n\nProfile added successfully!" : "\n\nError adding profile!"
    enter_key
  end

  def search_profile(user)
    result = @social_network.search_profile(user, 1)

    if result
      result.each do |_, profile| 
        puts "\nUSER > @#{profile.user}\nE-MAIL > #{profile.email}"
      end
    else
      puts "\nNo profile found with the given criteria."
    end

    enter_key
  end

  # posts methods

  def add_post
    puts "\n❖ Add Post\n\n"
    print "\nEnter Text\n> "
    text = gets.chomp
    print "\nEnter User\n> "
    user = gets.chomp
    
    result = @social_network.search_profile(user, 2)
    if result.nil?
      puts "\nNo profile found with this user."
      enter_key
    end
    success = nil

    loop do
      print "\nAdd hahstags (y/n): "
      option = gets.chomp.downcase

      if option == 'y'
        print "\nEnter hashtags (separated by commas)\n> "
        input = gets.chomp
        hashtags = input.split(',').map(&:strip)

        success = @social_network.add_post(
          text: text, likes: 0, dislikes: 0, date: Time.now, profile: result,
          hashtags: hashtags, remaining_views: 100)
        break
      elsif option == 'n'
        success = @social_network.add_post(
          text: text, likes: 0, dislikes: 0, date: Time.now, profile: result)
        break
      end
    end

    puts success ? "\n\nPost added successfully!" : "\n\nError creating post!"
    enter_key
  end

  def search_hashtag(hashtag)
    result = @social_network.show_post_by_hashtag(hashtag)

    if result
      result.each do |post|
        post_print = "\n@#{post.profile.user}\n#{post.text}\n#{post.date}"
        post_print << "\n\n" + post.hashtags.map { |hashtag| "##{hashtag}" }.join(" ") if post.instance_of?(AdvancedPost)
        puts "#{post_print}\n\n▲ #{post.likes}  ▼#{post.dislikes}"
      end
    else
      puts "\nNo post found with this hashtag."
    end

    enter_key
  end
end

app = App.new
app.menu