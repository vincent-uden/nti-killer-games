require 'awesome_print'
require 'pg'
require 'bcrypt'
require 'faker'

require_relative '../database/database'
require_relative '../database/models/code_words'
require_relative '../database/models/users'
require_relative './generate-codes'
require_relative '../utils.rb'


def create_users()
  codes = get_code_words 300
  codes.shuffle

  users = []

  (0..299).each do |n|
    new_user = User.null_user
    name = Faker::Name.name
    new_user.set_first_name name.split(" ")[0]
    new_user.set_last_name name.split(" ")[1]
    new_user.set_email Faker::Internet.unique.safe_email
    new_user.set_class (["1", "2", "3"].sample + ["A", "B", "C", "D", "E"].sample)
    new_user.set_code codes[n]
    new_user.set_alive true
    new_user.save
    p new_user
  end

end
