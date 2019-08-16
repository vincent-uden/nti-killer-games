require_relative 'tables'

class MailHandler
  @google_password ||= File.read('/home/vdesktop/.killergames/mail-pw.txt').chomp

  def self.send_reset_email(token, user_id)
    user = User.get id: user_id
    Pony.mail(
      to: user.get_email,
      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        enable_starttls_auto: true,
        user_name: 'noreply.killergames@gmail.com',
        password: @google_password,
        authentication: :plain,
        domain: 'HELO'
      },
      subject: 'NTI Killergames, Återställ lösenord',
      headers: { 'Content-Type' => 'text/html' },
      body: "<h1>Återställ ditt lösenord</h1><a href=\"https://localhost:9292/account/newpw?token=#{token}\">localhost:9292/account/newpw?token=#{token}</a>"
    )
    # TODO: Change to real domain
  end

end

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

    MailHandler.send_reset_email(token, user_id)
  end
end
