class Tag

  include DataMapper::Resource

  property :id, Serial
  property :name, String
  has n, :tags, through: Resource
  has n, :links, through: Resource
end