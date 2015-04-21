require 'rails_helper'

feature "the signup process" do

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end

  feature "signing up a user" do
    it "shows username on the homepage after signup" do
      visit new_user_url
      fill_in('User Name', with: 'johndoe')
      fill_in('Password', with: 'cookies')
      click_button('Submit')
      expect(page).to have_content('johndoe')
    end
  end

  feature "logging in" do
    it "shows username on the homepage after login" do
      create(:user)
      visit new_session_url
      fill_in('User Name', with: 'johndoe')
      fill_in('Password', with: 'cookies')
      click_button('Submit')
      expect(page).to have_content('johndoe')
    end
  end

  feature "logging out" do
    it "begins with logged out state" do
      visit new_session_url
      expect(page).to_not have_content('johndoe')
      visit new_user_url
      expect(page).to_not have_content('johndoe')
    end

    it "doesn't show username on the homepage after logout" do
      create(:user)
      visit new_session_url
      fill_in('User Name', with: 'johndoe')
      fill_in('Password', with: 'cookies')
      click_button('Submit')
      click_button('Log Out')
      expect(page).to_not have_content('johndoe')
    end
  end
end
