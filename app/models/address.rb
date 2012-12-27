class Address
  include Mongoid::Document

  field :address, type: string

  embedded_in :contact

end