# frozen_string_literal: true

# class Profile Controller
class ProfileController
  def add(params)
    return false if params.any? { |_, value| value.nil? } ||
      !@profile_repo.search_to_add(user: params[:user], email: params[:email]).nil?
    
    @profile_repo.add(params)
    true
  end

  def search(user, reason, profile_repo)
    if reason == 1
      profile_repo.search(user)
    elsif reason == 2
      profile_repo.search_to_add(user: user)
    end
  end
end