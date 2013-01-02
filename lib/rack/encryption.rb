require 'openssl'
require 'json'
Dir[File.join(File.dirname(__FILE__), "**/*.rb")].each {|f| require f}

module Rack

  # This class performs ciphering of sensitive data:
  #  - password
  #  - email
  #  - login
  #  - name
  # The client generates RSA key, sends public key to server.
  # Server generates AES key and iv, stores it in DB-based session and
  # Responds with RSA-public encrypted AES key, iv and plain session id.
  # The client then decrypts response and has AES key, iv

  
  class Encryption
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      @env=env
      path=@env['PATH_INFO']
      method=@env['REQUEST_METHOD']
      return response_with_AES_params if path=='/getkey' and method=~/^get$/i
      return response_with_decrypted_personal_fields if path=~/users/ and method=~/^post|put$/i
      @app.call @env
    end

  
    protected

    def response_with_AES_params
      clear_sessions_db      
      aes=Cipher::Aes.new
      session=KeySession.create :key=>aes.key, :iv=>aes.iv
      begin
        rsa=Cipher::Rsa.new @env['HTTP_PUBLIC_KEY']
        # RSA cipher capacity is limited => cipher key and iv separately, not the whole JSON
        Response.new({
                       :key=>rsa.encrypt(session.key),
                       :iv=>rsa.encrypt(session.iv),
                       :key_session_id=>session.id
                     }.to_json).finish
      rescue
        [401,{},[]]
      end
    end

    def response_with_decrypted_personal_fields
      params=@env['action_dispatch.request.request_parameters']
      if user=params && params['user']
        begin
          session=KeySession.find(params['key_session_id'].to_i)
          cipher=Cipher::Aes.new :key=>session.key, :iv=>session.iv
          %w(login password email name).each do |field|
            user[field]&&=cipher.decrypt user[field]
          end
        rescue
          return [401,{},[]]
        end
      end
      status, headers, body=@app.call @env
      [status, headers, body]
    end

    def clear_sessions_db
      if KeySession.count > 10000
        KeySession.where('created_at <= ?', 1.hour.ago).delete_all
      end
    end
    
  end
  
end
