# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module My
      module Quoting # :nodoc:
        extend ActiveSupport::Concern # :nodoc:
        module ClassMethods # :nodoc:
          def quote_column_name(column_name)
            %("#{column_name.to_s.gsub('"', '""')}")
          end
        end
      end
    end
  end
end
