module DynamicAttributes
  module Extendable
    extend ActiveSupport::Concern

    included do
      after_initialize do
        create_custom_accessors
      end
    end

    # Override to return an array of dynamic attributes
    def dynamic_attributes
      []
    end

    # Create type aware getters and setters
    def create_custom_accessors
      convert_to = {:integer => :to_i, :date => :to_date, :string => :to_s}

      dynamic_attributes.each do |attr|
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

  class DynamicAttr
    include Mongoid::Document

    ATTR_TYPES = [:string, :integer, :date]

    field :name, type: Symbol
    field :type, type: Symbol

    embedded_in :company

  end

end