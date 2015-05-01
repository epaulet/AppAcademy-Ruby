require_relative '03_associatable'

module Associatable
  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      through_class = through_options.model_class
      through_foreign_key_attr = through_options.foreign_key
      through_foreign_key_value = attributes[through_foreign_key_attr]
      through_instance = through_class.find(through_foreign_key_value)

      source_options = through_class.assoc_options[source_name]
      source_class = source_options.model_class
      source_foreign_key_attr = source_options.foreign_key
      source_foreign_key_value = through_instance.attributes[source_foreign_key_attr]

      source_class.find(source_foreign_key_value)
    end
  end
end
