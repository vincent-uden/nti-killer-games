require_relative 'tables'

class CodeWord < Table
  table_name 'code_words'
  column :id
  column :word
  prep_generic_stmts

  def initialize(db_hash)
    super(db_hash)
  end

  def self.valid_code?(code)
    code_parts = code.split("-")
    words = select_all.map { |w| w.values[1] }
    valid = true
    code_parts.each do |p|
      valid = valid && (words.include? p)
    end
    valid && code != ""
  end
end
