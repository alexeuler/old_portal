module Rack
  module Cipher
    
    # This class encapsulates RSA algorithm.
    # All outputs are base-64 encoded.
    # Input is modulus - a long string of numbers
    # If modulus is not passed in the constructor, it generates random modulus    
    # Before using, requires modulus to be set, also known as 'n' in RSA algorithm.
    # Modulus is a string of numbers, i.e. '8567375275983457987'.
    # Modulus and exponent=3 (default on client side) are sufficient to define RSA public key.
    
    class Rsa

      def initialize(modulus=nil)
        key.n=OpenSSL::BN.new(modulus) if modulus
      end

      def key
        @key||=OpenSSL::PKey::RSA.generate(512,3)
      end
    
      def encrypt(message)
        Base64::encode64(key.public_encrypt(message))
      end

      def decrypt(message)
        key.private_decrypt(Base64::decode64(message))
      end
 
    end
  end
end

