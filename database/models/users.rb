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

  def save
    prev_user = self.class.select where: "email = $1", values: [get_email]
    if prev_user.empty?
      self.class.insert @column_values[1..-1]
    else
      prev_user = User.new prev_user.first
      diffs = {}
      self.class.get_columns.each_with_index do |col, index|
        if prev_user.column_values[index] != column_values[index]
          diffs[col.name] = column_values[index]
        end
      end

      if diffs.length > 0
        query = "UPDATE users SET "
        index = 1
        diffs.each do |name, value|
          query += "#{name.to_s} = $#{index}, "
          index += 1
        end
        query = query[0..-3]
        query += " WHERE id = $#{index};"
      end
      dp diffs
      dp query
      Database.exec_params query, diffs.values + [get_id]
    end
  end

  def self.null_user
    User.new({
      "id" => 0,
      "first_name" => "Null",
      "last_name" => "User",
      "email" => "nulluser@null.com",
      "class" => "Null",
      "password" => "Null",
      "code" => "null-null-null",
      "target_id" => 0,
      "kills" => 0,
      "score" => 0,
      "alive" => false
    })
  end
end
