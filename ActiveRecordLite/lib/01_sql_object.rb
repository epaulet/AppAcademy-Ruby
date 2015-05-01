require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    table = DBConnection::execute2 <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      LIMIT 1
    SQL

    column_names = table.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col_name|
      define_method(col_name) do
        attributes[col_name]
      end

      define_method("#{col_name}=") do |value|
        attributes[col_name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection::execute <<-SQL
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    results = DBConnection::execute <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = #{id}
    SQL

    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attribute = attr_name.to_sym

      unless self.class.columns.include?(attribute)
        raise "unknown attribute '#{attribute}'"
      end

      send("#{attribute}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |col_name|
      send(col_name)
    end
  end

  def insert
    columns = self.class.columns
    DBConnection::execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{columns.join(', ')})
      VALUES
        (#{(["?"] * columns.length).join(', ')})
    SQL

    send("#{:id}=", DBConnection.last_insert_row_id)
  end

  def update
    set_string = self.class.columns.map do |col_name|
      "#{col_name} = ?"
    end.join(', ')

    DBConnection::execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_string}
      WHERE
        id = ?
    SQL
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end
end
