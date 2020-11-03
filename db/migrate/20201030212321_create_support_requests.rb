class CreateSupportRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :support_requests do |t|
      t.string  :email,   comment:  "Emails of the submitter"
      t.string  :subject, comment:  "Subject of their support email"
      t.text    :body,    comment:  "Body of their support email"

      t.references :order,
        foreign_key: true,
        comment: "Their most recent order, if applicable"

      t.timestamps
    end
  end
end
