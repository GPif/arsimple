# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module My
      module DatabaseStatements
        # Determines whether the SQL statement is a write query.
        def write_query?(sql)
          read_query = ActiveRecord::ConnectionAdapters::AbstractAdapter.build_read_query_regexp(
            :pragma
          )
          !read_query.match?(sql)
        end

        def primary_keys(_tables)
          r = internal_exec_query("PRAGMA table_info([shows]);")
          pk = r.to_a.find { |r| r["pk"] == 1 }
          return pk["name"] if pk

          nil
        end

        private

        def perform_query(raw_connection, intent, binds, type_casted_binds, prepare:, notification_payload:, batch:)
          total_changes_before_query = raw_connection.total_changes
          stmt = raw_connection.prepare(intent)
          begin
            unless binds.nil? || binds.empty?
              stmt.bind_params(type_casted_binds)
            end
            result = if stmt.column_count.zero? # No return
                       stmt.step
                       affected_rows = raw_connection.total_changes > total_changes_before_query ? raw_connection.changes : 0
                       ActiveRecord::Result.empty(affected_rows: affected_rows)
                     else
                       rows = stmt.to_a
                       affected_rows = raw_connection.total_changes > total_changes_before_query ? raw_connection.changes : 0
                       ActiveRecord::Result.new(stmt.columns, rows, stmt.types.map do |t|
                         type_map.lookup(t)
                       end, affected_rows: affected_rows)
                     end
          ensure
            stmt.close
          end
          result
        end

        def cast_result(result)
          # Given that SQLite3 doesn't have a Result type, raw_execute already returns an ActiveRecord::Result
          # so we have nothing to cast here.
          result
        end
      end
    end
  end
end
