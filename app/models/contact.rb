class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include CompanyScoped

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :addresses
  embeds_many :emails
  embeds_many :phones

end

class Address
  include Mongoid::Document

  field :address, type: String

  embedded_in :contact

end

class Email
  include Mongoid::Document

  field :email, type: String

  embedded_in :contact

end

class Phone
  include Mongoid::Document

  field :phone, type: String

  embedded_in :contact

end
