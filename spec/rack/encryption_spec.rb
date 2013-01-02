require File.join(File.dirname(__FILE__), "helpers.rb")
require 'spec_helper'
require 'rack/encryption'
require 'rack'

module Rack
  
  describe Encryption do
    include Helpers
    before(:each) do
      @app=stub('app').as_null_object
      @encryption=Encryption.new @app
    end
    
    context 'http get /getkey' do
      before(:each) do
        @rsa=Cipher::Rsa.new
        aes=Cipher::Aes.new
        @aes={
          'key'=>aes.key,
          'iv'=>aes.iv        
        }
        Cipher::Aes.any_instance.stub(:key).and_return(@aes['key'])
        Cipher::Aes.any_instance.stub(:iv).and_return(@aes['iv'])      
        @env={
          'HTTP_PUBLIC_KEY'=>@rsa.key.n.to_s,
          'PATH_INFO'=>'/getkey',
          'REQUEST_METHOD'=>'GET'
        }
      end

      it 'deletes older than 1 hour key sessions if # of sessions >10000' do
        KeySession.delete_all
        KeySession.stub(:create)
        KeySession.connection.execute "INSERT INTO `key_sessions` (`created_at`) VALUES #{(1..10000).map{|i| time_to_sql_format(i>9000 ? Time.now : 1.hour.ago)}.join(", ")}"
        @encryption.call @env
        KeySession.count.should == 10000

        KeySession.connection.execute "INSERT INTO `key_sessions` (`created_at`) VALUES #{time_to_sql_format(Time.now)}"
        @encryption.call @env        
        KeySession.count.should == 1001
        KeySession.delete_all        
      end
      
      context 'HTTP_PUBLIC_KEY header holds valid public key' do
        before(:each) do
          @response=@encryption.call @env
        end

        it "returns 200" do
          @response[0].should == 200
        end
        
        it "returns a body with RSA encrypted AES key, iv, plain session_id (id for plain key and iv, stored on server-side)" do
          data=JSON.parse(@response[2].body[0])
          data.keys.should=~%w(key iv key_session_id)
          data.each_pair do |hash_key,value|
            case hash_key
            when 'key', 'iv'
              value=@rsa.decrypt(value)              
              value.should == @aes[hash_key]
            when 'key_session_id'
              session=KeySession.find_by_id(value)
              session.key.should == @aes['key']
              session.iv.should == @aes['iv']
            end
          end
        end
        
      end
      
      context 'HTTP_PUBLIC_KEY header is corrupt' do
        
        it "returns 401" do
          ['',0,'1234567890123456'].each do |key|
            @env['HTTP_PUBLIC_KEY']=key
            @encryption.call(@env)[0].should == 401
          end
        end
        
      end
      
    end

    context 'http any other request' do
      
      it "passes through the request and response unchanged" do
        hash={}
        %w(GET DELETE POST PUT).each do |method|
          %w(/ /sign_up /home /forum dfgdf).each do |path|
            @env={
              'PATH_INFO'=>path,
              'REQUEST_METHOD'=>method
            }
            should_not_alter_request_and_response(@env) unless method=~/POST|PUT/ and path=='/users'
          end
        end
      end
      
    end

    context 'http post /users/*' do
      before(:each) do 
        @env={
          'PATH_INFO'=>'/users/dkfgjdfkgj',
          'REQUEST_METHOD'=>'POST'
        }
      end
      
      context "request has valid session_id" do
        before(:each) do
          cipher = Cipher::Aes.new          
          session=KeySession.create :key=>cipher.key, :iv=>cipher.iv
          @message="Really Long Message to check encryption"
          enc_message=cipher.encrypt(@message)
          @env['action_dispatch.request.request_parameters']={
            'user'=>{
              'login'=>enc_message,
              'email'=>enc_message,
              'name'=>enc_message,
              'password'=>enc_message,
              'plain'=>@message
            },
            'key_session_id' => session.id
          }
        end
     
        it "decrypts login email name and password" do
          @app.should_receive(:call)
          @encryption.call(@env)
          %w(login email name password plain).each do |item|
            @env['action_dispatch.request.request_parameters']['user'][item].should == @message
          end
        end
        
      end
      
      context "request has invalid session_id" do
        context "data has login or email or password or name" do
          before(:each) do
            @env['action_dispatch.request.request_parameters']={
              'user'=>{
                'login'=>'Just some text'
              }
            }
          end
          
          it "returns 401" do
            @encryption.call(@env)[0].should == 401
          end
          
        end

        context "data hasn't login or email or password or name" do
          before(:each) do
            @env['action_dispatch.request.request_parameters']=nil
          end

          it "passes through the request" do
            should_not_alter_request_and_response(@env)            
          end

        end
        
      end
    end
  end

 
end



