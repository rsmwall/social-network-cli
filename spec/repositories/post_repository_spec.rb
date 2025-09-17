require_relative '../../app/repositories/post_repository'
require_relative '../../app/models/post'
require_relative '../../app/models/advanced_post'
require_relative '../../app/models/profile'
require 'json'
require 'fileutils'
require 'tempfile'

RSpec.describe PostRepository do
  # Creates a temporary file for each test that requires persistence
  # This file is automatically cleaned up at the end of the test
  let(:tempfile) { Tempfile.new('posts.json') }
  let(:post_repository) { PostRepository.new }
  let(:profile) { Profile.new(id: 1, name: 'User Test', user: 'testuser', email: 'test@test.com', password: 'pwd', desc: 'desc') }

  # Overwrites the save and load methods to use the temporary file
  before do
    allow(post_repository).to receive(:save).and_wrap_original do |m, *args|
      data = post_repository.posts.map { |_, value| value.to_h }
      tempfile.write(JSON.pretty_generate(data))
      tempfile.rewind # Resets the file pointer to the beginning so it can be read
    end

    allow(post_repository).to receive(:load).and_wrap_original do |m, profiles|
      return unless File.exist?(tempfile.path)
      data = JSON.parse(File.read(tempfile.path))
      data.each do |post_hash|
        profile = profiles[post_hash['profile_id']]
        next unless profile
        post = if post_hash.key?('hashtags')
                 AdvancedPost.from_h(post_hash, profile)
               else
                 Post.from_h(post_hash, profile)
               end
        post_repository.posts[post.id] = post
        post.profile.add(post)
      end
    end
  end

  describe '#add' do
    it 'adds a regular post to the repository' do
      params = { text: 'Hello world!', profile: profile, date: '2025-01-01', likes: 0, dislikes: 0 }
      post_repository.add(params)
      expect(post_repository.posts.size).to eq(1)
      expect(post_repository.posts[1]).to be_an_instance_of(Post)
      expect(post_repository.posts[1].text).to eq('Hello world!')
      expect(post_repository.posts[1].profile.id).to eq(profile.id)
    end

    it 'adds an advanced post with hashtags to the repository' do
      params = { text: 'Ruby is fun #ruby #programming', hashtags: ['ruby', 'programming'], profile: profile, date: '2025-01-01', likes: 0, dislikes: 0 }
      post_repository.add(params)
      expect(post_repository.posts.size).to eq(1)
      expect(post_repository.posts[1]).to be_an_instance_of(AdvancedPost)
      expect(post_repository.posts[1].hashtag?('ruby')).to be true
    end
  end

  describe '#search' do
    before do
      # Adds posts for the search
      post_repository.add(text: 'Hello world! #test', hashtags: ['test'], profile: profile, date: '2025-01-01', likes: 0, dislikes: 0)
      post_repository.add(text: 'Another post here', profile: profile, date: '2025-01-02', likes: 0, dislikes: 0)
    end

    context 'when searching by text' do
      it 'returns posts that include the search text' do
        results = post_repository.search(text: 'Hello')
        expect(results.size).to eq(1)
        expect(results.first.text).to include('Hello')
      end

      it 'returns an empty array if no post matches the text' do
        results = post_repository.search(text: 'nonexistent')
        expect(results).to be_empty
      end
    end

    context 'when searching by hashtag' do
      it 'returns advanced posts that have the hashtag' do
        results = post_repository.search(hashtags: 'test')
        expect(results.size).to eq(1)
        expect(results.first).to be_an_instance_of(AdvancedPost)
        expect(results.first.hashtag?('test')).to be true
      end

      it 'returns an empty array if no post has the hashtag' do
        results = post_repository.search(hashtags: 'ruby')
        expect(results).to be_empty
      end
    end

    context 'when searching by id' do
      it 'returns the post with the matching id' do
        results = post_repository.search(id: 2)
        expect(results.size).to eq(1)
        expect(results.first.id).to eq(2)
      end
    end
  end

  describe '#persistence' do
    let(:loaded_profile) { Profile.new(id: 1, name: 'User Test', user: 'testuser', email: 'test@test.com', password: 'pwd', desc: 'desc') }
    let(:profiles_hash) { { 1 => loaded_profile } }

    before do
      # Adds posts to be saved
      post_repository.add(text: 'Saved post #data', hashtags: ['data'], profile: profile, date: '2025-01-01', likes: 0, dislikes: 0)
    end

    it 'saves posts to a JSON file' do
      post_repository.save
      expect(File.exist?(tempfile.path)).to be true
      content = JSON.parse(File.read(tempfile.path))
      expect(content.size).to eq(1)
      expect(content.first['text']).to eq('Saved post #data')
      expect(content.first['hashtags']).to eq(['data'])
    end

    it 'loads posts from a JSON file' do
      # Saves a post to the file
      post_repository.save

      # Creates a new repository and loads the data
      new_post_repository = PostRepository.new
      # Ensures that the new repository uses the test path
      allow(new_post_repository).to receive(:load).and_wrap_original do |m, profiles|
         return unless File.exist?(tempfile.path)
          data = JSON.parse(File.read(tempfile.path))
          data.each do |post_hash|
            profile = profiles[post_hash['profile_id']]
            next unless profile
            post = if post_hash.key?('hashtags')
                      AdvancedPost.from_h(post_hash, profile)
                    else
                      Post.from_h(post_hash, profile)
                    end
            new_post_repository.posts[post.id] = post
            post.profile.add(post)
          end
      end

      new_post_repository.load(profiles_hash)

      expect(new_post_repository.posts.size).to eq(1)
      loaded_post = new_post_repository.posts.values.first
      expect(loaded_post).to be_an_instance_of(AdvancedPost)
      expect(loaded_post.text).to eq('Saved post #data')
      expect(loaded_post.profile.id).to eq(1)
    end
  end
end