require_relative 'tables'

class User < Table
  table_name 'users'
  column :id
  column :first_name
  column :last_name
  column :email
  column :class
  column :password
  column :code
  column :target_id
  column :kills
  column :score
  column :alive
  prep_generic_stmts

  def initialize(db_hash)
    super(db_hash)
  end
end
