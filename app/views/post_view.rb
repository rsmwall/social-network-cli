# frozen_string_literal: true

require 'tty-prompt'

# class Post View
class PostView
  def initialize(social_network, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
    @app = app
  end

  def create(current_user)
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Create Post\n\n"
    text = @prompt.multiline('Text:', required: true)
    hashtags = text.to_s.scan(/#\w+/)
    hashtags.map! { |it| it.slice!(1..) }

    success = create_verification(text.join, hashtags, current_user)
    success ? @prompt.ok("\nPost added successfully!") : @prompt.error("\nError creating post!")

    @prompt.keypress("\nPress Enter to return to feed...", keys: [:return])
    @app.feed
  end

  def print_posts(posts)
    choices = posts.map { |post| { name: post_preview(post), value: post } }
    choices << 'Back to menu'
    selected_post = @prompt.select('', choices, show_help: :always, cycle: true, per_page: 20)
    @app.main_menu if selected_post == 'Back to menu'

    Gem.win_platform? ? system('cls') : system('clear')
    puts format_post(selected_post)

    post_actions(selected_post)
  end

  def post_preview(post)
    time = Time.parse(post.date.to_s)
    formatted_time = time.strftime('%b %d, %Y, %-I:%M %p')
    "#{post.profile.name} @#{post.profile.user} - #{formatted_time} - ▲ #{post.likes}  ▼ #{post.dislikes}"
  end

  def format_post(post)
    time = Time.parse(post.date.to_s)
    formatted_time = time.strftime('%b %d, %Y, %-I:%M %p')
    highlighted_text = post.text.gsub(/#\w+/) { |hashtag| "\e[34m#{hashtag}\e[0m" }

    post_print = "\n\e[1m#{post.profile.name}\e[0m @#{post.profile.user}\n\n#{highlighted_text}"
    post_print << "\n\n#{formatted_time}\n\n▲ #{post.likes}  ▼ #{post.dislikes}\n\n"

    post_print
  end

  private

  def create_verification(text, hashtags, current_user)
    if hashtags.empty?
      @social_network.add_post(
        text: text, likes: 0, dislikes: 0, date: Time.now, profile: current_user
      )
    else
      @social_network.add_post(
        text: text, likes: 0, dislikes: 0, date: Time.now, profile: current_user,
        hashtags: hashtags
      )
    end
  end

  def post_actions(post)
    @prompt.select('', show_help: :always, cycle: true) do |it|
      it.choice 'Like', -> { post.like }
      it.choice 'Dislike', -> { post.dislike }
      it.choice 'Back to feed', -> { @app.feed }
    end
  end
end
