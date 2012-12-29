class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :custom_contact_attrs, type: Hash, default: {}  # keys are attribute name and values are attribute type

  has_many :users
  has_many :contacts

  validates_presence_of :name

  class << self
    def current
      Thread.current[:current_company]
    end

    def current=(company)
      Thread.current[:current_company] = company
    end
  end

end

module Company::CompanyScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :company
    before_validation { self.company = Company.current }
    default_scope(lambda { {:where => {:company_id => Company.current}} })
  end
end
