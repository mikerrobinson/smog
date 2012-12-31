class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Company::CompanyScoped

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

  after_initialize do
    create_custom_accessors
  end

  # Create type aware getters and setters for custom contact attributes
  def create_custom_accessors
    convert_to = { :integer => :to_i, :date => :to_date, :string => :to_s }

    Company.current.contact_attrs.each do |attr|
      metaclass = class << self
        self
      end
      metaclass.send(:define_method, :"#{attr.name}=") do |val|
        self[attr.name] = val.send(convert_to[attr.type])
      end
      metaclass.send(:define_method, :"#{attr.name}") do
        self[attr.name]
      end
    end
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
