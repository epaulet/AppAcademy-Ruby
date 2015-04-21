FactoryGirl.define do
  factory :goal do
    body "Eat more vegetables"
    user build(:user)
    completed false
    is_private false
  end
end
