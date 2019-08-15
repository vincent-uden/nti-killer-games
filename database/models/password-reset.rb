require_relative 'tables'

class PasswordReset < Table
  table_name 'password_resets'
  column :token
  column :ts
  column :user_id

  def initialize(db_hash)
    super(db_hash)
  end

  def get_timestamp
    result = Database.exec_params 'SELECT extract(epoch from ts) FROM password_resets WHERE token = $1', [get_token]
    result[0]["date_part"].to_i
  end

  def self.create_password_reset(user_id)
    token = SecureRandom.hex 16
    ts = Database.exec('SELECT extract(epoch from now())')[0]["date_part"]
    Database.exec_params 'INSERT INTO password_resets (token, ts, user_id) VALUES ($1, to_timestamp($2), $3)', [BCrypt::Password.create(token), ts, user_id]
  end

  def self.send_reset_email(token, user_id)
  end
end
