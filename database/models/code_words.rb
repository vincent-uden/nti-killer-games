require_relative 'tables'

class CodeWord < Table
  table_name 'code_words'
  column :id
  column :word
  prep_generic_stmts

  def initialize(db_hash)
    super()

    set_id db_hash["id"]
    set_word db_hash["word"]
  end
end
