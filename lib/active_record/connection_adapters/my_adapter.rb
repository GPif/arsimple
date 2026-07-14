require "active_record"
require "active_record/connection_adapters/abstract_adapter"

require "active_record/connection_adapters/my_adapter/quoting"
require "active_record/connection_adapters/my_adapter/database_statements"
require "active_record/connection_adapters/my_adapter/schema_statements"

module ActiveRecord
    module ConnectionAdapters
        class MyAdapter < AbstractAdapter
            include MyAdapter::Quoting
            include MyAdapter::DatabaseStatements
            include MyAdapter::SchemaStatements
        end
        register("my_adapter", "ActiveRecord::ConnectionAdapters::MyAdapter", "active_record/connection_adapters/my_adapter")
    end
end
