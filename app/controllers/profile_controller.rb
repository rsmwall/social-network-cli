# frozen_string_literal: true

# class Profile Controller
class ProfileController
  def add(params, profile_repository)
    return false if params.any? { |_, value| value.nil? } ||
                    !profile_repository.search_to_add(user: params[:user], email: params[:email]).nil?

    profile_repository.add(params)
    true
  end

  def search(user, reason, profile_repository)
    if reason == 1
      profile_repository.search(user)
    elsif reason == 2
      profile_repository.search_to_add(user: user)
    end
  end

  def follow(current, profile)
    current&.following << profile.id
    profile&.followers << current.id
  end

  def unfollow(current, profile)
    current&.following.delete(profile.id)
    profile&.followers.delete(current.id)
  end

  def following?(current, profile)
    profile&.followers.include?(current.id)
  end
end
