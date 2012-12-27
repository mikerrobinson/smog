# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    name 'Test Company'
    custom_fields [:custom_field_1, :custom_field_2]
  end
end
