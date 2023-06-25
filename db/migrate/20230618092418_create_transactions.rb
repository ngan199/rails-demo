class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :display
      t.number :year
      t.number :month
      t.float :total

      t.timestamps
    end

    create_table :expenses do |t|
      t.belongs_to :transaction
      t.belongs_to :catagory
      t.string :name
      t.float :amount
      t.string :file_upload

      t.timestamps
    end
  end
end
