require 'pry'
require 'active_record'
require_relative 'contact'
# require_relative 'contact_list'

# Output messages from Active Record to standard out
ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'arcontact',
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'

puts 'Setting up Database (recreating tables) ...'

ActiveRecord::Schema.define do
  drop_table :contact_lists if ActiveRecord::Base.connection.table_exists?(:contact_lists)
  drop_table :contacts if ActiveRecord::Base.connection.table_exists?(:contacts)
  create_table :contact_lists do |t|
    t.column :name, :string
    t.timestamps null: false
  end
  create_table :contacts do |table|
    table.references :contact_list
    table.column :name, :string
    table.column :email, :string
    table.timestamps null: false
  end
end

puts 'Setup DONE'


def populate
  require 'faker'

  10.times do
    Contact.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
    )
  end
end

populate