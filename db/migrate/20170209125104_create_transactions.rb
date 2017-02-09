class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string   :name, limit: 255
      t.boolean  :active
      t.string  :status

      t.timestamps
    end
  end
end
