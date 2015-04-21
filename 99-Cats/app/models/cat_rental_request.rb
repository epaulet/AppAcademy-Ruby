class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :no_approved_requests_may_overlap

  after_initialize do |rental_request|
    rental_request.status ||= 'PENDING'
  end

  belongs_to(
    :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id
  )

  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  def pending?
    status == 'PENDING'
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = 'APPROVED'
      save

      overlapping_pending_requests.each do |request|
        request.status = 'DENIED'
        request.save
      end
    end
  end

  def deny!
    self.status = 'DENIED'
  end

  def no_approved_requests_may_overlap
    if overlapping_approved_requests.any? && status == "APPROVED"
      errors.add(:status, "Your request conflicts with another approved rental.")
    end
  end

  def overlapping_approved_requests
    overlapping_requests.select { |request| request.status == 'APPROVED' }
  end

  def overlapping_pending_requests
    overlapping_requests.select { |request| request.status == 'PENDING' }
  end

  def overlapping_requests
    id = self.id.nil? ? 0 : self.id

    CatRentalRequest.find_by_sql ([<<-SQL, end_date, start_date, id])
      SELECT
        *
      FROM
        cat_rental_requests
      WHERE
        cat_id = #{cat_id} AND NOT (start_date > ? OR end_date < ?) AND id != ?
    SQL
  end
end
