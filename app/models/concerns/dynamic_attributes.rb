module DynamicAttributes
  extend ActiveSupport::Concern

  included do
    after_initialize do
      create_accessors
    end
  end

  # MUST OVERRIDE to return the array of DynamicAttr for the current model instance
  def dynamic_attributes
    []
  end

  # Create type aware getters and setters
  def create_accessors
    convert_to = {:integer => :to_i, :date => :to_date, :string => :to_s}

    metaclass = class << self
      self
    end
    dynamic_attributes.each do |attr|
      metaclass.send(:define_method, :"#{attr.name}=") do |val|
        self[attr.name] = val.send(convert_to[attr.type])
      end
      metaclass.send(:define_method, :"#{attr.name}") do
        self[attr.name]
      end
    end
  end

  class DynamicAttr
    include Mongoid::Document

    ATTR_TYPES = [:string, :integer, :date]

    field :name, type: Symbol
    field :type, type: Symbol
  end

end