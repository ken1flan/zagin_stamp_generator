ROM::SQL.migration do
  change do
    add_column :image_histories, :size, String
  end
end
