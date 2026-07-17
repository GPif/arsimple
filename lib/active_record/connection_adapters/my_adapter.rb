# frozen_string_literal: true

require "active_record"
require "active_record/connection_adapters/abstract_adapter"

require "active_record/connection_adapters/my/quoting"
require "active_record/connection_adapters/my/database_statements"
require "active_record/connection_adapters/my/schema_statements"

require "sqlite3"

module ActiveRecord
  module ConnectionAdapters
    class MyAdapter < AbstractAdapter
      include My::Quoting
      include My::DatabaseStatements
      include My::SchemaStatements

      class << self
        def new_client
          ::SQLite3::Database.new(":memory:")
        rescue Errno::ENOENT => e
          raise ActiveRecord::NoDatabaseError if e.message.include?("No such file or directory")

          raise
        end

        def native_database_types
          {
            primary_key: "integer PRIMARY KEY AUTOINCREMENT NOT NULL",
            string: { name: "varchar" },
            text: { name: "text" },
            integer: { name: "integer" },
            float: { name: "float" },
            decimal: { name: "decimal" },
            datetime: { name: "datetime" },
            time: { name: "time" },
            date: { name: "date" },
            binary: { name: "blob" },
            boolean: { name: "boolean" },
            json: { name: "json" }
          }
        end
      end

      def reconnect
        @raw_connection = self.class.new_client
      end
    end
    register("my_adapter", "ActiveRecord::ConnectionAdapters::MyAdapter",
             "active_record/connection_adapters/my_adapter")
  end
end
