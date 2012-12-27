class Email
  include Mongoid::Document

  field :email, type: string

  embedded_in :contact

end