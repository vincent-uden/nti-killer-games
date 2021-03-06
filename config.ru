# config for rackup

require 'bundler'
Bundler.require

require_relative 'app'
require_relative 'utils'
require_relative 'database/database'
require_relative 'database/models/tables'
require_relative 'database/models/code_words'
require_relative 'database/models/users'
require_relative 'database/models/gamestate'
require_relative 'database/models/password-reset'
require_relative 'database/models/sold_codes'
require 'webrick/https'
require 'securerandom'

use Rack::SSL

Rack::Server.start(
  :Port             => 9292,
  :Host             => '0.0.0.0',
  :Logger           => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :app              => App,
  :SSLEnable        => true,
  :SSLVerifyClient  => OpenSSL::SSL::VERIFY_NONE,
  :SSLPrivateKey    => OpenSSL::PKey::RSA.new( File.read __dir__ + "/ssl-certs/pkey.pem" ),
  :SSLCertificate   => OpenSSL::X509::Certificate.new( File.read __dir__ + "/ssl-certs/cert.crt" ),
  :SSLCertName      => [["CN", WEBrick::Utils::getservername]]
)      
