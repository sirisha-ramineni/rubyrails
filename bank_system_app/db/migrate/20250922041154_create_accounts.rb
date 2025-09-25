class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.string :account_holder
      t.decimal :balance
      t.string :account_type
      t.references :bank, null: false, foreign_key: true

      t.timestamps
    end
  end
end
