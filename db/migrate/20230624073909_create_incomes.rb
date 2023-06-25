class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :display
      t.number :year
      t.number :month
      t.string :total

      t.timestamps
    end

    create_table :income_details do |t|
      t.belongs_to :income
      t.string :name
      t.string :amount

      t.timestamps
    end
  end
end
