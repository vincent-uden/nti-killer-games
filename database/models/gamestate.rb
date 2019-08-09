require_relative 'tables'

class GameState < Table
  table_name 'gamestate'
  column :current_state
  prep_generic_stmts

  @states = [ :pregame, :gamerunning, :postgame ]

  def initialize(db_hash)
    super(db_hash)
  end

  def self.states
    @states
  end

  def self.get_state
    states[select_all[0]["current_state"]]
  end

  def self.running?
    get_state == :gamerunning
  end

  def self.pregame?
    get_state == :pregame
  end
  
  def self.postgame?
    get_state == :postgame
  end
end
