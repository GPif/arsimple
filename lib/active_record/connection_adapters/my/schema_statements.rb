# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module My
      module SchemaStatements
        def data_source_sql(name = nil, type: nil)
          scope = quoted_scope(name, type: type)
          scope[:type] ||= "'table','view'"

          sql = +"SELECT name FROM pragma_table_list WHERE schema <> 'temp'"
          sql << " AND name NOT IN ('sqlite_sequence', 'sqlite_schema')"
          sql << " AND name = #{scope[:name]}" if scope[:name]
          sql << " AND type IN (#{scope[:type]})"
          sql
        end

        def quoted_scope(name = nil, type: nil)
          type = \
            case type
            when "BASE TABLE"
              "'table'"
            when "VIEW"
              "'view'"
            when "VIRTUAL TABLE"
              "'virtual'"
            end
          scope = {}
          scope[:name] = quote(name) if name
          scope[:type] = type if type
          scope
        end

        private

        def new_column_from_field(_table_name, field, _definitions)
          default_function = nil

          Column.new(
            field["name"],
            lookup_cast_type(field["type"]),
            field["dflt_value"],
            fetch_type_metadata(field["type"]),
            field["notnull"].to_i.zero?,
            default_function,
            collation: field["collation"]
          )
        end
      end
    end
  end
end
