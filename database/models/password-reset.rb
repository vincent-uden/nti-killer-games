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
      body: "<h1>Återställ ditt lösenord</h1><p>Hej #{user.get_first_name}!<br>Vi har nyligen fått en ansökan om att återställa lösenordet på ditt konto. Om detta var du följer du länken nedan för att välja ett nytt lösenord. Annars borde du dubbelkolla säkerheten på ditt mail-konto och radera detta mail.</p><a href=\"https://#{$domain_name}:9292/account/newpw?token=#{token}&email=#{user.get_email}\">https://#{$domain_name}:9292/account/newpw?token=#{token}&email=#{user.get_email}</a>"
    )
    # TODO: Change to real domain
  end

end

class PasswordReset < Table
  table_name 'password_resets'
  column :token
  column :ts
  column :user_id
  prep_generic_stmts

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

  def self.validate_token(token, email)
    user = User.get email: email
    # There might be several tokens stored for a given user
    rows = PasswordReset.select where: 'user_id = $1', order_by: 'ts DESC', values: [user.get_id]

    selected_row = nil
    # BCrypt is slow so we loop from the most recent token towards
    # the oldest, stopping if we find the right one
    rows.each do |row|
      if BCrypt::Password.new(row['token']) == token
        selected_row = PasswordReset.new row
        break
      end
    end
    
    selected_row != nil
  end

  def self.set_new_password(new_pw, token, email)
    # Password and token is already validated in app.rb
    user = User.get email: email
    Database.exec_params 'DELETE FROM password_resets WHERE user_id = $1', [user.get_id]
    user.set_password BCrypt::Password.create(new_pw)
    user.save
  end
end
