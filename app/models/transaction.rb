class Transaction < ApplicationRecord
    has_many :expenses, dependent: :destroy
    accepts_nested_attributes_for :expenses

    def reject_expenses(attributes)
        attributes['transaction_id'].blank?
    end 
end
