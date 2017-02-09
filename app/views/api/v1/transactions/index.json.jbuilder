json.transactions do
  json.array!(@transactions) do |transaction|
    json.extract! transaction, :id, :name, :created_at, :status
  end
end
