class Transaction < ApplicationRecord
    has_many :expenses, dependent: :destroy
    accepts_nested_attributes_for :expenses
end
