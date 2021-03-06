require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_string = params.map do |col_name, value|
      "#{col_name} = ?"
    end.join(" AND ")

    results = DBConnection::execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_string}
    SQL

    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
