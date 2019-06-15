class Column
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Table
  def initialize
    @column_values = []
  end

  def self.table_name(name)
    @table_name = name
  end

  def self.get_table_name
    @table_name
  end

  def self.column(*args)
    if @columns == nil
      @columns = []
    end
    @columns << (Column.new args[0])
  end

  def self.get_columns
    @columns
  end

  def self.prep_generic_stmts
    # Insert
    insert_query = "INSERT INTO #{get_table_name} ("
    get_columns.each do |col|
      insert_query += col.name.to_s + ", "
    end
    insert_query = insert_query[0..-3]
    insert_query += ") VALUES ("
    get_columns.each_with_index do |col, index|
      insert_query += "$#{index+1}, "
    end
    insert_query = insert_query[0..-3]
    insert_query += ");"
    Database.prepare "insert_#{get_table_name}", insert_query
  end

  def self.insert(values)
    Database.exec_prepared "insert_#{get_table_name}", values
  end

  def self.select_all
    Database.exec("SELECT * FROM #{get_table_name};")
  end

  def method_missing(method_name, *args, &blk)
    if method_name.to_s[0..3] == "get_"
      col_name = method_name.to_s[4..-1]
      self.class.get_columns.each_with_index do |col, index|
        if col.name == col_name.to_sym
          return @column_values[index]
        end
      end
      raise "Column #{col_name} does not exist"
    elsif method_name.to_s[0..3] == "set_"
      col_name = method_name.to_s[4..-1]
      self.class.get_columns.each_with_index do |col, index|
        if col.name == col_name.to_sym
          @column_values[index] = args[0]
          return
        end
      end
      raise "Column #{col_name} does not exist"
    end
    super(method_name, *args, &blk)
  end
end
