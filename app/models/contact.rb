class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include CompanyScoped
  include DynamicAttributes

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :addresses
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  embeds_many :emails
  accepts_nested_attributes_for :emails, :allow_destroy => true
  embeds_many :phones
  accepts_nested_attributes_for :phones, :allow_destroy => true


  # Dynamic attributes are incompatible with attr_accessible as it occurs at the class level so use attr_protected
  #attr_protected

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
