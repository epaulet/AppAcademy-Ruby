require 'rails_helper'

feature "a user" do

  it "can comment on users and their goals and view all comments on users & goals" do
    john = create(:user)
    goal = create(:goal, user_id: john.id)

    chris = build(:user, username: "chris")
    sign_up(chris)
    click_link('johndoe')
    click_button('add_user_comment')
    fill_in('Comment', with: "You're very heathy!")
    click_button('Submit')
    expect(page).to have_content("You're very healthy!")

    click_button("add_comment_to_goal_#{goal.id}")
    fill_in('Comment', with: "I hate vegetables :(")
    click_button('Submit')
    expect(page).to have_content("To eat more vegetables")
    expect(page).to have_content("I hate vegetables :(")

  end
end
