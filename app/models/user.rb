class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :transactions, dependent: :destroy
  accepts_nested_attributes_for :transactions

  has_many :incomes, dependent: :destroy
  accepts_nested_attributes_for :incomes

  # def reject_transactions(attributes)
  #   attributes['user_id'].blank? 
  # end 
end
