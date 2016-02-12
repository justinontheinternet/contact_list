# Represents a person in an address book.
class Contact

  attr_accessor :name, :email, :phone_numbers
  attr_reader :id


  def initialize(name, email, id=nil)
    @id = id
    @name = name
    @email = email
  end

  def save
    if self.id == nil
      result = self.class.connection.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2);', [self.name, self.email])
    else
      result = self.class.connection.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int;', [self.name, self.email, self.id.to_i])
    end
  end

  def destroy
    Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1', [self.id])
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    def connection
      @@connection ||= PG.connect(dbname: 'contact_orm')
    end

    # Returns an Array of Contacts loaded from the database.
    def all
      all_contacts = []
      result = connection.exec('SELECT * FROM contacts;')
      result.each do |each_contact|     #result = an array of hashes. Each hash is a contact/ro
        contact = Contact.new(
          each_contact['name'],
          each_contact['email'],
          each_contact['id']
          )
        all_contacts << contact         #push each contact (now an instance/object), into the all contacts array
      end
      all_contacts                      #return the array full on instances
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    # def create(new_contact)
    #   new_contact.save
    # end

    def find(id)
      result = connection.exec_params('SELECT id, name, email FROM contacts WHERE id = $1::int;', [id])
      if row = result.first
        Contact.new(row['name'], row['email'], row['id'])
      else
        nil
      end
    end

    def search(term)
      result = connection.exec_params("SELECT * FROM contacts WHERE LOWER(name) LIKE LOWER('%' || $1 || '%') OR LOWER(email) LIKE LOWER('%' || $1 || '%');", [term])
    end
  end
end
