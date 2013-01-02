module Rack
  module Cipher
    # This class encapsulates AES CBC 256 algorithm.
    # All inputs and outputs are base-64 encoded.
    # If key or iv are not passed in the constructor, it generates random key or iv
    # Padding 16 is used, i.e. encrypted message length % 16 should == 0
    # o/w it's filled with zero bytes to be %16 == 0
    # Keys have native OpenSSL representation, i.e. string of bytes.
    # To convert to array of integer use key.bytes.to_a,
    # to convert array of integer to string of bytes use array.pack('c*').  

    class Aes
      
      def initialize(params={})
        @key=params[:key]||key
        @iv=params[:iv]||iv
      end

      def key
        @key||=Base64::encode64 OpenSSL::Cipher::AES.new(256, :CBC).random_key
      end

      def iv
        @iv||=Base64::encode64 OpenSSL::Cipher::AES.new(256, :CBC).random_iv
      end

      def encrypt(message)
        cipher = make_cipher @key, @iv, 'encrypt'
        padded=pad(message)
        encrypted=cipher.update(padded)+cipher.final
        Base64::encode64(encrypted)        
      end

      def decrypt(message)
        cipher = make_cipher @key, @iv, 'decrypt'        
        decoded=Base64::decode64(message)
        decrypted=cipher.update(decoded)+cipher.final
        depad(decrypted)
      end
     
      def depad(text)
        text.gsub(/\x00/,'')
      end

      def pad(text)
        number_to_add=16-((text.length-1) % 16 + 1)
        (1..number_to_add).inject(text) {|str, i| str+="\x00"}
      end


      protected
      
      def make_cipher(key,iv,encrypt_or_decrypt)
        cipher = OpenSSL::Cipher::AES.new(256, :CBC)
        encrypt_or_decrypt=='encrypt' ? cipher.encrypt : cipher.decrypt
        cipher.key=Base64.decode64 key
        cipher.iv=Base64.decode64 iv 
        cipher.padding=0
        cipher
      end
      
    end
  end
end
