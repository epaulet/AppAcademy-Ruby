require 'rails_helper'

feature "goals" do

  it "cannot see goals if not logged in" do

    visit goals_url
    expect(page).to have_content("Sign In")

  end

  feature "can manipulate own goals" do

  before :each do
    john = build(:user)
    sign_up(john)
    visit goals_url
    find(:css, '#create_goal').click
    fill_in('Goal', with: "Eat More Vegetables")
    choose('public')
    click_button('make_goal')
  end

  let(:goal) { Goal.find_by_body("Eat More Vegetables") }

    it "can create goals" do
      expect(page).to have_content("Eat More Vegetables")
    end

    it "can edit goals" do
      click_button("edit_goal_#{goal.id}")
      expect(page).to have_content("Edit Goal")
      fill_in('Goal', with: "Eat more fruits & vegetables" )
      click_button('make_goal')
      expect(page).to have_content("Eat more fruits & vegetables")
      expect(page).to_not have_content("Eat More Vegetables")
    end

    it "can complete goals" do
      click_button("complete_goal_#{goal.id}")
      expect(page).to_not have_content("complete_goal_#{goal.id}")
    end

    it "can delete goals" do
      click_button("delete_goal_#{goal.id}")
      expect(page).to_not have_content("Eat More Vegetables")
    end
  end

  feature "looking at the goals index" do

    before :each do
      john = build(:user)
      sign_up(john)
      visit goals_url
      find(:css, '#create_goal').click
      expect(page).to have_css('form.goal')
      fill_in('Goal', with: "Eat More Vegetables")
      choose('public')
      click_button('make_goal')

      find(:css, '#create_goal').click
      fill_in('Goal', with: "Be nicer to my wife")
      choose('private')
      click_button('make_goal')
      click_button('Log Out')

      chris = build(:user, username: 'chris')
      sign_up(chris)
      visit goals_url
      find(:css, '#create_goal').click
      fill_in('Goal', with: "To work out more")
      choose('public')
      click_button('make_goal')

      find(:css, '#create_goal').click
      fill_in('Goal', with: "To drink less")
      choose('private')
      click_button('make_goal')
    end

    it "can see all users' public goals" do
      expect(page).to have_content("Eat More Vegetables")
    end

    it "can view all own goals" do
      expect(page).to have_content("To work out more")
      expect(page).to have_content("To drink less")
    end

    it "cannot see other users' private goals" do
      expect(page).to_not have_content("Be nicer to my wife")
    end

    it "cannot edit others' goals" do
      goal = Goal.find_by_body("Eat More Vegetables")
      expect(page).to_not have_content("edit_goal_#{goal.id}")
      
      visit edit_goal_url(goal)
      expect(page).to have_content("To work out more")
    end
  end
end
