require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  attr_accessor :user_input

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def menu
    puts "Here is a list of available commands:"
    puts "\tnew\t- Create a new contact"
    puts "\tlist\t- List all contacts"
    puts "\tshow\t- Show a contact"
    puts "\tsearch\t- Search contacts"
    @user_input = gets.chomp
  end

  def list
      num = 0
    Contact.each do | row |
      num += 1
      puts "#{num}: #{row[0]}   #{row[1]}   #{row[2]}"
    end
  end

  def new_contact
    temp_numbers = {}
    puts "Enter name (first and last):"
    name = gets.chomp
    puts "Enter email:"
    email = gets.chomp
    puts "Add phone numbers? 'yes' or 'no'"
    enter_numbers = gets.chomp
    if enter_numbers == "yes"
      loop do
        puts "Enter number label ('home', 'mobile', etc):"
        label = gets.chomp.to_sym
        puts "Enter the phone number:"
        number = gets.chomp
        temp_numbers[label] = number
        puts "Add another number? 'yes' or 'no'"
        answer = gets.chomp.downcase
        break if answer == "no"
      end
    end
    if check_email(email)
      puts "A contact with that email already exists. Contact was not created."
    else
      Contact.create(name, email, temp_numbers)
    end
  end

  def check_email(new_email)
    CSV.foreach("data.csv") do |row|
      return true if row.any? { |ele| ele =~ /#{new_email}/i }
    end
  end



  def find_by_id
    puts "Enter ID number:"
    id = gets.chomp
    puts Contact.find(id)[0]
    puts Contact.find(id)[1]
  end

  def find_by_search_term
    puts "What do you want to search for?"
    search_term = gets.chomp
    puts "#{CSV.read("data.csv").find_index(Contact.search(search_term)) + 1}. #{Contact.search(search_term).join("   ")}"
  end

end

def start_list
  new_list = ContactList.new
  new_list.menu
  case new_list.user_input
  when "list"
    new_list.list
  when "new"
    new_list.new_contact
  when "show"
    new_list.find_by_id
  when "search"
    new_list.find_by_search_term
  end
   

end

start_list