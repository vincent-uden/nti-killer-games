# config for rackup

require 'bundler'
Bundler.require

require_relative 'app'
require 'webrick/https'


Rack::Server.start(
  :Port             => 9292,
  :Logger           => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :app              => App,
  :SSLEnable        => true,
  :SSLVerifyClient  => OpenSSL::SSL::VERIFY_NONE,
  :SSLPrivateKey    => OpenSSL::PKey::RSA.new( File.read "pkey.pem" ),
  :SSLCertificate   => OpenSSL::X509::Certificate.new( File.read "cert.crt" ),
  :SSLCertName      => [["CN", WEBrick::Utils::getservername]]
)      
