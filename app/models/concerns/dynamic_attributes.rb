module DynamicAttributes
  extend ActiveSupport::Concern

  included do
    after_initialize do
      create_accessors
    end
  end

  # Override to return an array of dynamic attributes
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

  # Add support for mass assignment
  def make_accessible
    metaclass = class << self
      self
    end
    metaclass.send(:attr_accessible, dynamic_attributes)
  end

  class DynamicAttr
    include Mongoid::Document

    ATTR_TYPES = [:string, :integer, :date]

    field :name, type: Symbol
    field :type, type: Symbol

    embedded_in :company

  end

end