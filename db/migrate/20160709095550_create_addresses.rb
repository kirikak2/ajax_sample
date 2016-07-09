class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :name_kana
      t.string :gender
      t.string :phone
      t.string :mail
      t.string :zipcode
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.string :address5
      t.integer :age
    end
  end
end
