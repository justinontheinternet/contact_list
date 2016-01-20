# Represents a person in an address book.
class Contact < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true

  belongs_to :contact_list

end
