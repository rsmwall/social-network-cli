# **Social Network CLI**

The **Social Network CLI** is a project originally created as an academic assignment in TypeScript. Later, it was rewritten in **Ruby**, bringing numerous improvements and additional features compared to the original version.

---

## **Table of Contents**
1. [Project Description](#project-description)
2. [Features](#features)
3. [Project Structure](#project-structure)
4. [Installation Guide](#installation-guide)
5. [Testing](#testing)
6. [Contributing](#contributing)
7. [License](#license)
8. [Contact](#contact)

---

## **Project Description**

This project provided an opportunity to study and apply various programming concepts and best practices, such as:

- Object-Oriented Programming (OOP) in **Ruby**;
- A modular architecture that emulates the **MVC** pattern;
- Managing data persistence with **JSON**;
- Encrypting passwords with **bcrypt**;
- Creating terminal interfaces with **tty-prompt**;
- Managing dependencies with **Bundler**;
- Maintaining clean and organized code with **Rubocop**;
- Writing unit tests with **RSpec**;
- Ensuring clean and isolated tests with **Tempfile**.

---

## **Features**

### **Security and Authentication**
- Protected login with credential validation.
- User registration functionality.
- Passwords securely stored using **bcrypt**.

### **Profile Management**
- Create profiles during registration.
- View your own profile or other users' profiles.
- List all posts of a specific profile.

### **Post Management**
- Create posts with or without **hashtags**.
- Highlight hashtags, displayed in blue.
- Search posts by text or hashtags.

### **Search Mechanism**
- Search for:
  - Posts containing specific text.
  - Hashtags (starting with `#`).
  - Users (starting with `@`).

### **Interactions**
- Like or dislike posts.
- Follow or unfollow profiles:
  - Options dynamically change based on the current state (following or not).

### **Data Persistence**
- Automatically saves profiles and posts in **JSON** files.
- Data is loaded automatically when the program starts.

---

## **Project Structure**

The project follows a modular architecture for better scalability and maintainability:

```plaintext
social-network
├── app/
│   ├── controllers/                # Controllers (flow logic)
│   ├── data/                       # Persisted JSON data
│   ├── models/                     # Models (business logic)
│   ├── repositories/               # Data management repositories
│   ├── services/                   # Business logic encapsulation
│   └── views/                      # User-facing interfaces
├── spec/                           # Tests directory
│   ├── services/                   # Tests for the services layer
│   └── repositories/               # Tests for the repositories layer
├── app.rb                          # Main entry point
├── Gemfile                         # Dependency manager
├── Gemfile.lock                    # Locked dependency versions
├── License                         # Project license
└── README.md                       # Documentation
```

---

## **Installation Guide**

### **Prerequisites**

Make sure you have the following dependencies installed:

#### **Ruby**
- Version 3.0 or higher.
- Check your version with:
  ```bash
  ruby --version
  ```
- Install from the official site: [ruby-lang.org](https://www.ruby-lang.org).

#### **Bundler**
- Install using:
  ```bash
  gem install bundler
  ```

---

### **Installation Steps**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rsmwall/social-network-cli.git
   cd social-network-cli
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Set up data files:**
   Create the necessary directories and files:
   ```bash
   mkdir -p app/data
   echo '[]' > app/data/profiles.json
   echo '[]' > app/data/posts.json
   ```

4. **Run the application:**
   ```bash
   ruby app.rb
   ```

---

## Testing

This project uses RSpec for unit testing. The test suite is designed to ensure the reliability of key functionalities like authentication and data persistence.

### Running the Tests

To run the entire test suite, execute the following command in the project's root directory:

   ```bash
   bundle exec rspec
   ```

To run a specific test file, provide the path to the file:

   ```bash
   bundle exec rspec spec/services/authentication_spec.rb
   ```

---

## **Contributing**

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix:

   ```bash
   git checkout -b my-feature
   ```

3. Submit a **pull request** with your changes.

---

## **License**

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## **Contact**

**Author:** Rafael Silva  
**GitHub:** [rsmwall](https://github.com/rsmwall)  
**Email:** [rafaelrsilva.dev@gmail.com](mailto:rafaelrsilva.dev@gmail.com)  
**Bluesky:** [@rsmwall.bsky.social](https://bsky.app/profile/rsmwall.bsky.social) 