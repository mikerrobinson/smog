# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html

puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by(:name => role, :without_protection => true)
  puts 'role: ' << role
end

puts 'DEFAULT COMPANIES'
company = Company.find_or_create_by :name => 'Acme'
company.contact_attrs = [
    ContactAttr.new(:name => :nickname, :type => :string),
    ContactAttr.new(:name => :birthday, :type => :date)
]
company.save!
puts 'company: ' << company.name

puts 'DEFAULT USERS'
user = User.find_or_create_by :email => ENV['ADMIN_EMAIL'].dup
user.update_attributes(:name => ENV['ADMIN_NAME'].dup,
                       :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup)
puts 'user: ' << user.name
user.add_role :admin

user2 = User.find_or_create_by :email => 'user2@example.com'
user2.company = company
user2.update_attributes(:name => 'Silver User', :password => 'please', :password_confirmation => 'please')
user2.add_role :silver

user3 = User.find_or_create_by :email => 'user3@example.com'
user3.company = company
user3.update_attributes(:name => 'Gold User', :password => 'please', :password_confirmation => 'please')
user3.add_role :gold

user4 = User.find_or_create_by :email => 'user4@example.com'
user4.company = company
user4.update_attributes(:name => 'Platinum User', :password => 'please', :password_confirmation => 'please')
user4.add_role :platinum
puts "users: #{user2.name}, #{user3.name}, #{user4.name}"