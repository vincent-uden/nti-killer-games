require_relative 'helpers/spec_helper'

feature 'Generating Target Sequence' do
  scenario 'Includes every person', type: 'seq' do
    Database.exec 'UPDATE users SET target_id = 0;'
    old_users = User.select_all.map { |u| User.new u }
    generate_sequence
    new_users = User.select_all.map { |u| User.new u }

    expect(old_users.length).to eq(new_users.length)

    check_list = new_users.dup

    first_user = new_users[0]
    current_user = new_users.detect { |u| u.get_id == first_user.get_target_id }
    until current_user == first_user do
      check_list.delete current_user
      current_user = new_users.detect { |u| u.get_id == current_user.get_target_id }
    end
    check_list.delete first_user

    expect(check_list.empty?).to eq(true)
  end
end
