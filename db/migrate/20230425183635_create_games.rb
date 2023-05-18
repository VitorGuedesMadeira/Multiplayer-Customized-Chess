class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.json :state
      t.integer :players
      t.integer :turn
      t.json :moves
      t.integer :time
      t.integer :status
      t.json :promotion
      t.integer :theme
      t.integer :mode

      t.timestamps
    end
  end
end
