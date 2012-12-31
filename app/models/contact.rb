class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Company::CompanyScoped

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :addresses
  embeds_many :emails
  embeds_many :phones

  after_initialize do
    create_custom_accessors
  end

  def create_custom_accessors
    # Create type aware getters and setters for custom contact attributes
    convert_to = {:integer => :to_i, :date => :to_date, :string => :to_s}

    Company.current.custom_contact_attrs.each do |attr, type|
      metaclass = class << self
        self
      end
      metaclass.send(:define_method, :"#{attr}=") do |val|
        self[attr] = val.send(convert_to[type])
      end
      metaclass.send(:define_method, :"#{attr}") do
        self[attr]
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
