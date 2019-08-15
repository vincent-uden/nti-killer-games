require_relative 'tables'
require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

class MailHandler
  @OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  @APPLICATION_NAME = "NTI Killer Games".freeze
  @CREDENTIALS_PATH = "/home/vdesktop/.killergames/credentials.json".freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  @TOKEN_PATH = "/home/vdesktop/.killergames/token.yaml".freeze
  @SCOPE = 'https://mail.google.com/'

  def self.authorize
    client_id = Google::Auth::ClientId.from_file @CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: @TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, @SCOPE, token_store

    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: @OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: @OOB_URI
      )
    end
    credentials
  end

  def self.init
    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = @APPLICATION_NAME
    @service.authorization = authorize
    
    @user_id = 'me'
  end

  def self.send_reset_email(token, user_id)
    init
    user = User.get id: user_id
    mail = Mail.new do
      to user.get_email
      from 'noreply.killergames@gmail.com'
      subject 'NTI Killergames, Återställ Lösenord'
      
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<h1>Återställ ditt lösenord</h1>"
      end
    end

        # <a href=\"localhost:9292/account/newpw?token=#{token}\">localhost:9292/account/newpw?token=#{token}</a>"

    raw_msg = mail.to_s
    puts raw_msg
    msg = Google::Apis::GmailV1::Message.new raw: raw_msg
    @service.send_user_message @user_id, msg
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
