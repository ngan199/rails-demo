class CreateBudgets < ActiveRecord::Migration[7.0]
  def change
    create_table :budgets do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :year
      t.string :month
      t.string :total

      t.timestamps
    end

    create_table :incomes do |t|
      t.belongs_to :budget 
      t.string :name 
      t.float :amount

      t.timestamps
    end
  end
end
