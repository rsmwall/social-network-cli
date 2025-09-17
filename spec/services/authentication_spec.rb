require_relative '../../app/services/authentication'
require_relative '../../app/repositories/profile_repository'
require 'bcrypt'

RSpec.describe Authentication do
  let(:profile_repository) { ProfileRepository.new }
  let(:authentication_service) { Authentication.new(profile_repository) }
  let(:user_password) { '123456' }
  let(:hashed_password) { BCrypt::Password.create(user_password) }

  # Test Scenario: An existing user with the correct password
  before do
    # Simulates adding a profile to the repository
    allow(profile_repository).to receive(:search_to_add).with(user: 'testuser').and_return(
      double('Profile', password: hashed_password, id: 1)
    )
    allow(profile_repository).to receive(:search_to_add).with(user: 'nonexistent').and_return(nil)
  end

  describe '#login' do
    context 'when user and password are correct' do
      it 'logs in the user and returns true' do
        result = authentication_service.login('testuser', user_password)
        expect(result).to be true
        expect(authentication_service.current_user).not_to be_nil
      end
    end

    context 'when the password is incorrect' do
      it 'does not log in the user and returns false' do
        result = authentication_service.login('testuser', 'wrongpassword')
        expect(result).to be false
        expect(authentication_service.current_user).to be_nil
      end
    end

    context 'when the user does not exist' do
      it 'does not log in the user and returns false' do
        result = authentication_service.login('nonexistent', 'anypassword')
        expect(result).to be false
        expect(authentication_service.current_user).to be_nil
      end
    end
  end

  describe '#logout' do
    it 'logs out the current user' do
      # First, log in a user so there is a 'current_user'
      authentication_service.login('testuser', user_password)
      expect(authentication_service.logged_in?).to be true

      # Now, test the logout
      result = authentication_service.logout
      expect(result).to be true
      expect(authentication_service.current_user).to be_nil
    end

    it 'returns false if no user is logged in' do
      # Ensures no user is logged in
      authentication_service.logout
      result= authentication_service.logout
      expect(result).to be false
    end
  end

  describe '#logged_in?' do
    it 'returns true when a user is logged in' do
      authentication_service.login('testuser', user_password)
      expect(authentication_service.logged_in?).to be true
    end

    it 'returns false when no user is logged in' do
      authentication_service.logout
      expect(authentication_service.logged_in?).to be false
    end
  end
end
