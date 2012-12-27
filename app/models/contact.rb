class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :addresses
  embeds_many :emails
  embeds_many :phones

end
