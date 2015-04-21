class RemoveDefaultUserIdFromCatRentalRequests < ActiveRecord::Migration
  def change
    change_column_default :cat_rental_requests, :user_id, nil
  end
end
