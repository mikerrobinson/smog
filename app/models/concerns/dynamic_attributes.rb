module DynamicAttributes
  extend ActiveSupport::Concern

  included do
    after_initialize do
      #create_accessors  # Part of dynamic getter/setter creation approach
      initialize_dynamic_attributes # Part of init approach
    end
  end

  # MUST OVERRIDE to return the array of DynamicAttr for the current model instance
  def dynamic_attributes
    []
  end

  #-- Begin init approach --
  def initialize_dynamic_attributes
    init_vals = {:integer => 0, :date => Time.now, :string => ""}
    dynamic_attributes.each do |attr|
      self[attr.name] = init_vals[attr.type] if self[attr.name].nil?
    end
  end
  #-- End init approach --

  #-- Begin method_missing approach --
  #def method_missing(meth, *args, &block)
  #  if dynamic_accessor?(meth)
  #    run_dynamic_accessor(meth, args.first)
  #  else
  #    super
  #  end
  #end
  #
  #def respond_to?(meth, include_private=false)
  #  if dynamic_accessor?(meth)
  #    true
  #  else
  #    super
  #  end
  #end
  #
  #def dynamic_accessor?(meth)
  #  not attr_for_accessor(meth).nil?
  #end
  #
  #def attr_for_accessor(meth)
  #  dynamic_attributes.each do |attr|
  #    if meth.to_s =~ /^#{attr.name}=?$/
  #      return attr
  #    end
  #  end
  #  return nil
  #end
  #
  #def run_dynamic_accessor(meth, val)
  #  convert_to = {:integer => :to_i, :date => :to_time, :string => :to_s}
  #  attr = attr_for_accessor(meth)
  #  if meth.to_s.end_with?('=')
  #    val.send(convert_to[attr.type]) unless val.nil?
  #    self[attr.name] = val
  #  else
  #    self[attr.name]
  #  end
  #end
  #-- End method_missing approach --

  #-- Begin dynamic getter/setter creation approach --
  ## Create type aware getters and setters
  #def create_accessors
  #  convert_to = {:integer => :to_i, :date => :to_time, :string => :to_s}
  #
  #  metaclass = class << self
  #    self
  #  end
  #  dynamic_attributes.each do |attr|
  #    metaclass.send(:define_method, :"#{attr.name}=") do |val|
  #      val = val.send(convert_to[attr.type]) unless val.nil?
  #      self[attr.name] = val
  #    end
  #    metaclass.send(:define_method, :"#{attr.name}") do
  #      self[attr.name]
  #    end
  #  end
  #end
  #-- End dynamic getter/setter creation approach --

  class DynamicAttr
    include Mongoid::Document

    ATTR_TYPES = [:string, :integer, :date]

    field :name, type: Symbol
    field :type, type: Symbol

    validates_presence_of :name, :type
  end

end