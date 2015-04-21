class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :gender, :user_id, presence: true
  validates :color, inclusion: { in: %w(white orange black calico brown) }
  validates :gender, inclusion: { in: %w(M F) }

  has_many(
    :rental_requests,
    class_name: 'CatRentalRequest',
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
  )

  belongs_to(
    :owner,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  def age
    ((Date.today - birth_date)/365).to_i
  end

  def sorted_requests
    rental_requests.sort_by { |request| request.start_date }
  end
end
