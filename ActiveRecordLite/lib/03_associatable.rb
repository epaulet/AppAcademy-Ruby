require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.to_s.constantize
  end

  def table_name
    class_name.to_s.constantize.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    default_hash = { :class_name => name.to_s.camelcase,
                     :foreign_key => "#{name.to_s}_id".to_sym,
                     :primary_key => :id }

    @class_name, @foreign_key, @primary_key = default_hash.merge(options).
      values_at(:class_name, :foreign_key, :primary_key)
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    default_hash = { :class_name => name.to_s.singularize.camelcase,
                     :foreign_key => "#{self_class_name.downcase.singularize}_id".to_sym,
                     :primary_key => :id }


    @class_name, @foreign_key, @primary_key = default_hash.merge(options).
      values_at(:class_name, :foreign_key, :primary_key)
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key_id = send(options.primary_key)
      options.model_class.find(foreign_key_id)
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    foreign_key = options.foreign_key

    define_method(name) do
      options.model_class.where({ foreign_key => id })
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
