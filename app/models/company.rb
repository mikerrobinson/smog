class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  #field :custom_contact_attrs, type: Hash, default: {}  # keys are attribute name and values are attribute type

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

class ContactAttr
  include Mongoid::Document

  ATTR_TYPES = [:string, :integer, :date]

  field :name, type: Symbol
  field :type, type: Symbol

  embedded_in :company

end


module Company::CompanyScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :company
    before_validation { self.company = Company.current }
    default_scope(lambda { {:where => {:company_id => Company.current}} })
  end
end
