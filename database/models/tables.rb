class Column
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Table
  attr_reader :column_values
  def initialize(*args)
    @column_values = []
    if !args.empty?
      args[0].each do |col_name, val|
        self.send("set_#{col_name}", val)
      end
    end
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
      # Assumes all columns called id will be serial
      # autoincrementing keys
      if col.name != :id
        insert_query += col.name.to_s + ", "
      end
    end
    insert_query = insert_query[0..-3]
    insert_query += ") VALUES ("
    index = 1
    get_columns.each do |col|
      # Assumes all columns called id will be serial
      # autoincrementing keys
      if col.name != :id
        insert_query += "$#{index}, "
        index += 1
      end
    end
    insert_query = insert_query[0..-3]
    insert_query += ");"
    Database.prepare "insert_#{get_table_name}", insert_query

    # SELECT *
    select_query = "SELECT * FROM #{get_table_name};"
    Database.prepare "select_#{get_table_name}", select_query
  end

  def self.insert(values)
    Database.exec_prepared "insert_#{get_table_name}", values
  end

  def self.select_all
    Database.exec_prepared "select_#{get_table_name}"
  end

  # Method call will look like:
  # Table.select where: "column = value"
  def self.select(*args)
    if args.empty?
      select_all
    else
      options = args[0]
      query = "SELECT * FROM #{get_table_name}"
      if options[:where]
        query += " WHERE #{options[:where]}"
      end
      if options[:order_by]
        query += " ORDER BY #{options[:order_by]}"
      end
      query += ";"
      Database.exec_params query, options[:values]
    end
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
