# frozen_string_literal: true

require_relative './services/social_network.rb'

# class App
class App
  def initialize
    @social_network = SocialNetwork.new
    @menu = <<~MENU
    1. Add Profile        2. Search Profile
    3. Add Post           4. Search Post
    5. Feed               6. Show Posts Profile
    7. Show Posts Hashtag 8. Like 
    9. Dislike            0. Exit
    MENU
  end

  def menu
    system('clear')
    puts "> RafaBook\n\n"
    puts @menu
    print "\nEnter an option\n> "
    option = gets.chomp.to_i

    menu_action(option)
  end

  def action(option)
    case option
    when 1 then add_profile
    when 2 then search_profile
    when 3 then add_post
    when 4 then search_post
    when 5 then feed
    when 6 then show_post_profile
    when 7 then show_post_by_hashtag
    when 8 then like
    when 9 then dislike
    end
  end
end

app = App.new
app.menu