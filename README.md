# Social Network CLI

Social Network CLI is a command-line application that simulates a simple social network. This project enables users to manage profiles, create and interact with posts, and persist data in JSON files. It provides core functionalities of a social network with a minimalistic yet robust approach.

---

## Project Description

The **Social Network CLI** is designed for developers seeking to understand how to implement core social networking features such as profile management, hashtag-based post searching, and interaction systems (like/dislike). 

This project is ideal for:
- Learning Ruby object-oriented programming (OOP).
- Implementing repository patterns for data management.
- Managing JSON-based persistence.

---

## Features

- **Profile Management**:
  - Create, search, and view user profiles.
- **Post Management**:
  - Create posts with hashtags.
  - Search posts by hashtag.
- **Interactions**:
  - Like or dislike posts.
  - View posts with restricted access (limited views).
- **Data Persistence**:
  - Automatically save and load profiles and posts in JSON files.
- **Hashtag Functionality**:
  - Filter posts based on hashtags.

---

## Project Structure

The project follows a modular architecture, organizing components into distinct folders for clarity and maintainability.

```plaintext
social-network
├── app/
│   ├── data/                       # JSON data files for persistence
│   │   ├── posts.json              # Post data storage
│   │   ├── profiles.json           # Profile data storage
│   ├── models/                     # Business logic classes
│   │   ├── advanced_post.rb
│   │   ├── post.rb
│   │   └── profile.rb
│   ├── repositories/               # Repository classes for data management
│   │   ├── profile_repository.rb
│   │   └── post_repository.rb
│   └── services/                   # Business logic encapsulation
│       └── authentication.rb
│       └── mailtrap.rb
│       └── social_network.rb
├── .env                            # Environment variables (e.g., Mailtrap API keys)
├── app.rb                          # Main application entry point
├── Gemfile                         # Dependency manager
├── Gemfile.lock                    # Locked dependency versions
├── License
└── README.mb                       # Project documentation
```

## Installation Guide
### Prerequisites

Before starting, ensure you have the following installed:

- Ruby (version 3.0 or later): Install from [ruby-lang.org](https://www.ruby-lang.org).
- Bundler: Install with:
    ```bash
    gem install bundler
    ```

### Installation Steps

1. Clone this repository:

    ```bash
    git clone https://github.com/rsmwall/social-network-cli.git
    cd social-network-cli
    ```

- Install dependencies:

    ```bash
    bundle install
    ```

2. Set up environment variables: Create a .env file in the project root with the following content:

    ```env
    EMAIL_USER=your_email@mailtrap.io
    API_KEY=your_mailtrap_api_key
    ```

3. Create the necessary data directories and files (if it doesn't exist):

    ```bash
    mkdir -p app/data/repository app/data/post
    echo '[]' > app/data/repository/profiles.json
    echo '[]' > app/data/post/posts.json
    ```

4. Run the application:

    ```bash
    ruby app.rb
    ```

## Key Functionalities
### Profile Management

- Add a new profile.
- Search profiles by username or ID.

### Post Management

- Create posts with or without hashtags.
- Search for posts based on hashtags.
- Manage interactions: like, dislike, or view posts with limited access.

## Contributing

We welcome contributions to improve this project! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes and open a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

Author: Rafael Silva

GitHub: [rsmwall](https://github.com/rsmwall)

Email: rafaelrsilva.dev@gmail.com