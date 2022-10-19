class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_uuid
      t.string :emitter_name
      t.string :emitter_rfc
      t.string :receiver_rfc
      t.string :receiver_name
      t.string :status
      t.integer :amount
      t.integer :currency
      t.date :emitted_at
      t.date :expires_at
      t.date :signed_at
      t.text :cfdi_digital_stamp
      t.column :deleted_at, :datetime, :limit => 6
      t.timestamps
    end
  end
end
