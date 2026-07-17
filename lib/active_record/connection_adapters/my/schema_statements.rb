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
      end
    end
  end
end
