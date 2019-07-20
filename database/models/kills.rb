require_relative 'tables'

class Kill < Table
  table_name 'kills'
  column :killer_id
  column :victim_id
  prep_generic_stmts

  def initialize(db_hash)
    super(db_hash)
  end

  def self.create_new_kill(kill_info)
    insert [kill_info[:killer_id], kill_info[:victim_id]]
  end

end
