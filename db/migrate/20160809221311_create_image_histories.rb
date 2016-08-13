ROM::SQL.migration do
  change do
    create_table :image_histories do
      primary_key :id
      column :text, String
      column :font_name, String
      column :image_name, String
      column :pattern, String
    end
  end
end
