#!/usr/bin/env ruby
require 'pg'
require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  attr_reader :user_input

  def self.create_list
    new_list = ContactList.new
    new_list.menu
    case new_list.user_input
    when "list"
      new_list.list
    when "new"
      new_list.new_contact
    when "update"
      new_list.update_contact
    when "show"
      new_list.find_by_id
    when "search"
      new_list.find_by_search_term
    when "delete"
      new_list.delete_contact
    end
  end

  def menu
    puts "Here is a list of available commands:"
    puts "\tnew\t- Create a new contact"
    puts "\tupdate\t- Update contact info"
    puts "\tlist\t- List all contacts"
    puts "\tshow\t- Show a contact"
    puts "\tsearch\t- Search contacts"
    puts "\tdelete\t- Delete contact"
    @user_input = gets.chomp
  end

  def list
    (Contact.all).each do |contact|
      puts "#{contact.id}. #{contact.name}  (#{contact.email})"
    end
  end

  def new_contact
    temp_numbers = {}
    puts "Enter name (first and last):"
    name = gets.chomp
    puts "Enter email:"
    email = gets.chomp
    # puts "Add phone numbers? 'yes' or 'no'"
    # enter_numbers = gets.chomp
    # if enter_numbers == "yes"
    #   loop do
    #     puts "Enter number label ('home', 'mobile', etc):"
    #     label = gets.chomp.to_sym
    #     puts "Enter the phone number:"
    #     number = gets.chomp
    #     temp_numbers[label] = number
    #     puts "Add another number? 'yes' or 'no'"
    #     answer = gets.chomp.downcase
    #     break if answer == "no"
    #   end
    # end
    # if check_email(email)
    #   puts "A contact with that email already exists. Contact was not created."
    # else
      new_contact = Contact.new(name, email)
      new_contact.save
      puts "Contact was successfully added."
    # end
  end

  def update_contact
    puts "Enter the contact id you'd like to update."
    id = gets.chomp
    existing_contact = Contact.find(id)
    puts "Enter new name:"
    existing_contact.name = gets.chomp
    puts "Enter new email:"
    existing_contact.email = gets.chomp
    existing_contact.save
    puts "Contact updated."
  end

  def delete_contact
    puts "Enter the contact id you'd like to delete."
    id = gets.chomp
    existing_contact = Contact.find(id)
    existing_contact.destroy
    puts "Contact terminated."
  end

  def check_email(new_email)
    CSV.foreach("data.csv") do |row|
      return true if row.any? { |ele| ele =~ /#{new_email}/i }
    end
  end

  def find_by_id
    puts "Enter ID number:"
    id = gets.chomp
    contact = Contact.find(id)
    puts "#{contact.id}. #{contact.name}  (#{contact.email})"
  end

  def find_by_search_term
    puts "What do you want to search for?"
    search_term = gets.chomp
    search_result = Contact.search(search_term)
    search_result.each do |contact|
      puts "#{contact["id"]}. #{contact["name"]}  (#{contact["email"]})"
    end
  end
end

ContactList.create_list