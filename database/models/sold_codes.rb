require_relative 'tables'

# SQL Commands to create table
# CREATE table sold_codes (code TEXT);

class SoldCode < Table
  table_name 'sold_codes'
  column :code
  prep_generic_stmts

  def initialize(db_hash)
    super(db_hash)
  end

  def self.sold?(code)
    result = select where: 'code = $1', values: [code]
    return !result.empty?
  end

  def self.gen_new_code()
    words = CodeWord.select_all.map { |x| x['word'] }
    word = ""
    done = false
    while !done do
      index1 = rand(0..19)
      index2 = rand(20..39)
      index3 = rand(40..59)
      word = words[index1] + "-" + words[index2] + "-" + words[index3]
      done = !sold?(word)
    end
    code = SoldCode.new({ "code" => word })
    code.save
    word
  end

  def sold?
    p get_code
    result = self.class.select where: 'code = $1', values: [get_code]
    return !result.empty?
  end

  def save
    if !sold?
      self.class.insert @column_values
    end
  end
end
