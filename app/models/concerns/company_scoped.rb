module CompanyScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :company
    before_validation { self.company = Company.current }
    default_scope(lambda { {:where => {:company_id => Company.current}} })
  end
end
