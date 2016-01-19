require 'csv'

# Represents a person in an address book.
class Contact

  attr_accessor :name, :email, :phone_numbers

  @@file = CSV.read("data.csv")

  def initialize(name, email, phone_numbers = {})
    @name = name
    @email = email
  end

  def info_to_string
    if self.phone_numbers != nil
      "#{name} (#{email}) (#{@phone_numbers})"
    else
      "#{name} (#{email})"
    end
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      @@file.map do | row |
        contact = Contact.new(row[0], row[1])
        "#{@@file.index(row) + 1}. " + contact.info_to_string
      end
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email, phone_numbers = {})
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
       CSV.open('data.csv', 'a') do | csv |    #come back to this so it creates a new line when there isn't a blank one
          csv << [name, email, phone_numbers]
        end
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.  
      @@file[id.to_i - 1]         #Can I do this without reading whole file???
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      CSV.foreach("data.csv") do | row |
        binding.pry
        return row if row.any? { |ele| ele =~ /#{term}/i }
      end
    end

  end

end
