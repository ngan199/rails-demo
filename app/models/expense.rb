class Expense < ApplicationRecord
    validates :name, presence: true  
    validates :amount, presence: true , numericality: { only_integer: true, message: 'only accept number type.'}
end
