class Catagory < ApplicationRecord
    has_many :expenses, dependent: :destroy
end
