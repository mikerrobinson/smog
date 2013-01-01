class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include CompanyScoped
  include DynamicAttributes::Extendable

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :addresses
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  embeds_many :emails
  accepts_nested_attributes_for :emails, :allow_destroy => true
  embeds_many :phones
  accepts_nested_attributes_for :phones, :allow_destroy => true


  #TODO: Add the following line and test for compatibility of dynamic attributes
  #attr_accessible :first_name, :last_name, :addresses_attributes, :emails_attributes, :phones_attributes

  def dynamic_attributes
    Company.current.contact_attrs
  end
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
