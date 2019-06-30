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

  @valid_classes = [
    "1A",
    "1B",
    "1C",
    "1D",
    "1E",
    "2A",
    "2B",
    "2C",
    "2D",
    "2E",
    "3A",
    "3B",
    "3C",
    "3D",
    "3E"
  ]

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
      Database.exec_params query, diffs.values + [get_id]
    end
  end

  def null?
    get_id == 0
  end

  def self.valid_classes
    @valid_classes
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

  def self.get(identifier)
    if identifier[:email]
      result = select where: "email = $1", values: [identifier[:email]]
    elsif identifier[:id]
      result = select where: "id = $1", values: [identifier[:id]]
    elsif identifier[:code]
      result = select where: "code = $1", values: [identifier[:code]]
    end

    if result.empty?
      user = null_user
    else
      user = User.new result[0]
    end

    user
  end

  def self.login(browser_email, browser_pass, session)
    errors = []
    user = get email: browser_email
    if !(BCrypt::Password.new(user.get_password) == browser_pass && !(user.null?))
      errors << :wrong_password
    end

    if errors.empty?
      session[:user_id] = user.get_id
    end

    errors
  end

  def self.create_new_user(user_info)
    errors = []
    user = null_user
    # Validate first name
    if user_info["firstName"] == ""
      errors << :empty_first_name
    end

    # Validate last name
    if user_info["lastName"] == ""
      errors << :empty_last_name
    end

    # Check if email is availible
    if user_info["email"] == ""
      errors << :empty_email
    end
    if !((get email: user_info["email"]).null?)
      errors << :email_exists
    end

    # Validate class
    if !(valid_classes.include? user_info["class"])
      errors << :invalid_class
    end

    # Validate password
    if user_info["password"] == ""
      errors << :empty_password
    end
    if user_info["password"] != user_info["passwordConfirm"]
      errors << :password_dont_match
    end

    # Validate code word
    if !(CodeWord.valid_code? user_info["codeWord"])
      errors << :invalid_code_word
    end

    user.set_first_name user_info["firstName"]
    user.set_last_name user_info["lastName"]
    user.set_email user_info["email"]
    user.set_class user_info["class"]
    user.set_password user_info["password"]
    user.set_code user_info["codeWord"]

    if errors.empty?
      user.save
    end

    errors
  end
end
