class CreateUsers < ActiveRecord::Migration[7.0]
  # create_tableの場合、down_tableをrailsが認識しているのでchangeだけでいける
  # add_columnなどはupとdownを別々に定義する必要がある
  def change
    create_table :users do |t| #ブロック（TODO:復習)
      # 複雑なマイグレーション作りたい場合ってコマンドでカラム指定するかあとからマイグレ編集するかどっち？
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
