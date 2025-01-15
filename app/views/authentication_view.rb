# frozen_string_literal: true

require 'tty-prompt'

# class Authentication View
class AuthenticationView
  def initialize(social_network, auth_service, post_view, profile_view, app)
    @prompt = TTY::Prompt.new
    @social_network = social_network
    @auth_service = auth_service
    @profile_view = profile_view
    @post_view = post_view
    @app = app
  end

  def initial_menu
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Welcome!\n\n"
    @prompt.select('', show_help: :always, cycle: true) do |it|
      it.choice 'Login', -> { login }
      it.choice 'Sign-Up', -> { signup }
      it.choice 'Exit', -> { @app.exit }
    end
  end

  def login
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Login\n\n"
    login_info = @prompt.collect do
      key(:user).ask('User:')
      key(:password).mask('Password:')
    end

    login_verification(login_info)
  end

  def signup
    Gem.win_platform? ? system('cls') : system('clear')

    puts "\n❖ Signup\n\n"
    user = @prompt.ask('User:', required: true)
    email = @prompt.ask('Email:', required: true) do |q|
      q.validate(/\A\w+@\w+\.\w+\Z/, 'Invalid email address!')
    end

    password = password_confirmation
    signup_verification(user, email, password)

    @prompt.keypress("\nReturning to menu in :countdown", timeout: 2, keys: [:return])

    initial_menu
  end

  private

  def login_verification(login_info)
    if @auth_service.login(login_info[:user], login_info[:password])
      @prompt.ok("\nLogin successful!")
      @app.current_user = @auth_service.current_user
      sleep(2)
      @app.main_menu
    end

    @prompt.error("\nInvalid username or password!")
    sleep(2)

    login
  end

  def password_confirmation
    password = @prompt.ask('Password:', required: true)
    @prompt.ask('Repeat Password:', required: true) do |q|
      q.validate ->(input) { input == password }
      q.messages[:valid?] = 'Passwords do not match!'
    end

    password
  end

  def signup_verification(user, email, password)
    unless @social_network.add_profile(
      user: user, email: email, password: BCrypt::Password.create(password)
    )
      @prompt.error("\nUser or email is already in use!")
      sleep(2)

      signup
    end

    @prompt.ok("\nProfile added successfully!\n")
    @profile_view.customization(user)
  end

  public

  def logout
    Gem.win_platform? ? system('cls') : system('clear')

    if @auth_service.logout
      @prompt.ok("\nLogout successful!")
      sleep(2)

      initial_menu
    end

    @prompt.error("\nNo user logged in!")
    sleep(2)
    @app.main_menu
  end
end
