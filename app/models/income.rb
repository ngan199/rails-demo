class Income < ApplicationRecord
    has_many :income_details
    accepts_nested_attributes_for :income_details
end
