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
    puts "\n❖ RafaBook\n\n"
    puts @menu
    print "\nEnter an option\n> "
    option = gets.chomp.to_i

    menu_action(option)
  end

  def menu_action(option)
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

  def enter_key
    puts "\nPress Enter to return to the menu..."
    key = gets
    menu if key == "\n"
  end

  def build_search_params
    accepted_fields = %i[id user email]
    params = {}

    accepted_fields.each do |field|
      print "\nEnter #{field} (or press Enter to skip)\n> "
      value = gets.chomp
      value = value.to_i if field == 'id'
      params[field] = value.empty? ? nil : value
    end
  end

  def add_profile
    puts "\n❖ Add Profile\n\n"
    print "\nEnter an ID\n> "
    id = gets.chomp.to_i
    print "\nEnter an User\n> "
    user = gets.chomp
    print "\nEnter an E-mail\n> "
    email = gets.chomp

    success = @social_network.add_profile(id: id, user: user, email: email)
    puts success ? "\n\nProfile added successfully!" : "\n\nError adding profile!"
    enter_key
  end

  def search_profile
    puts "\n❖ Search Profile\n\n"
    search_params = build_search_params
    result = @social_network.search_profile(search_params)

    if result
      puts "\nProfile found."
      puts "\nID > #{result.id}\nUSER > @#{result.user}\nE-MAIL > #{result.email}"
    else
      puts "\nNo profile found with the given criteria."
    end

    enter_key
  end
end

app = App.new
app.menu