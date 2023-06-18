class Transaction < ApplicationRecord
    has_many :expenses, dependent: :destroy
end
