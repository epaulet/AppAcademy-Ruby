# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  validates :name, :email, :user_id, presence: true
  validates :email, :uniqueness => {:scope => :user_id}

  belongs_to(
    :owner,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'
  )

  has_many(
    :contact_shares,
    primary_key: :id,
    foreign_key: :contact_id,
    class_name: 'ContactShare',
    dependent: :destroy
  )

  has_many(
    :shared_users,
    through: :contact_shares,
    source: :user
  )
end
