# frozen_string_literal: true

RSpec.describe ActiveRecord::ConnectionAdapters::MyAdapter do
  it "connect to the db" do
    ActiveRecord::Base.establish_connection(
      adapter: "my_adapter",
      database: ":memory:" # As it is sqlite
    )
    expect(ActiveRecord::Base.connection.class).to eq(ActiveRecord::ConnectionAdapters::MyAdapter)
  end
  
  context "with a connection" do
    before(:context) do
      ActiveRecord::Base.establish_connection(
        adapter: "my_adapter",
        database: ":memory:" # As it is sqlite
      )
    end
    
    it "create a table" do
      expect {
        ActiveRecord::Schema.define(version: 1) do
          create_table :shows, force: true do |t|
            t.string :name
          end
        end
      }.not_to raise_error
    end
  end
      ActiveRecord::Schema.define(version: 1) do
        create_table :shows, force: true do |t|
          t.string :name
        end
      end
    end
  end
end
