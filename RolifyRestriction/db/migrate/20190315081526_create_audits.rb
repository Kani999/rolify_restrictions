class CreateAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :audits do |t|
      t.string :msg

      t.timestamps
    end
  end
end
