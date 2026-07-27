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
      expect do
        ActiveRecord::Schema.define(version: 1) do
          create_table :shows, force: true do |t|
            t.string :name
          end
        end
      end.not_to raise_error
    end
  end

  context "with connextion and schema" do
    before(:context) do
      ActiveRecord::Base.establish_connection(
        adapter: "my_adapter",
        database: ":memory:"
      )

      ActiveRecord::Schema.define(version: 1) do
        create_table :shows, force: true do |t|
          t.string :name
          t.integer :episodes
        end
      end
    end

    before(:example) do
      test_record = Class.new(ActiveRecord::Base)

      stub_const("Show", test_record)
    end

    it "create record" do
      s = Show.create(name: "Breaking Bad", episodes: 42)
      expect(s.id).not_to be_nil
      expect(Show.count).to eq(1)
      expect(Show.first.name).to eq("Breaking Bad")
    end

    it "update record" do
      s = Show.create(name: "Breaking Bad", episodes: 42)
      s.episodes = 47
      s.save!

      expect(s.reload.episodes).to eq(47)
    end
  end
end
