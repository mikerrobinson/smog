class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_many :users
  has_many :contacts
  embeds_many :contact_attrs
  accepts_nested_attributes_for :contact_attrs, :allow_destroy => true

  attr_accessible :name, :contact_attrs_attributes

  validates_presence_of :name

  default_scope(lambda { {:where => {:id => Company.current}} })

  class << self
    def current
      Thread.current[:current_company]
    end

    def current=(company)
      Thread.current[:current_company] = company
    end
  end

end

class ContactAttr < DynamicAttributes::DynamicAttr
  embedded_in :company
end
