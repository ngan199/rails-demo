class Income < ApplicationRecord
    has_many :income_details
    accepts_nested_attributes_for :income_details
    # validates :year, uniqueness: true
    # validates :month, uniqueness: true
end
