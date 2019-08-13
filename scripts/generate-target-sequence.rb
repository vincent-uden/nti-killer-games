require 'awesome_print'
require 'pg'

require_relative '../database/database'
require_relative '../database/models/code_words'
require_relative '../database/models/users'
require_relative './generate-codes'
require_relative '../utils.rb'

def generate_sequence
  users = User.select(where: "alive = true").map { |u| User.new u }
  users.shuffle!

  users.each_with_index do |user, index|
    user.set_target_id users[(index + 1) % users.length].get_id
  end

  users.each do |user|
    user.save
  end

  puts "Target Sequence Generated"
  users
end
