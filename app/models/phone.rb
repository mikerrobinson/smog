class Phone
  include Mongoid::Document

  field :phone, type: string

  embedded_in :contact

end