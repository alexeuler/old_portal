namespace 'Security', (exports) ->
        exports.SendSecurePassword = (ajaxOptions) ->
                passPhrase = 'Just another boring'
                RSAkey = cryptico.generateRSAKey(passPhrase, 512)
                publicKey=RSAkey.n.toString(10)
                ajaxGetAESOptions=
                        url:'/getkey'
                        type: 'GET'
                        beforeSend:(xhrObj)->
                                xhrObj.setRequestHeader("Public-Key",publicKey);
                $.ajax(ajaxGetAESOptions)
                .done((data, textStatus, jqXHR)->
                        aes_info=$.parseJSON(data)
                        aes_key_b64=RSAkey.decrypt(cryptico.b64to16(aes_info.key))
                        aes_key=Utils.UnpackString(cryptico.b64to256(aes_key_b64))
                        aes_iv_b64=RSAkey.decrypt(cryptico.b64to16(aes_info.iv))
                        aes_iv=Utils.UnpackString(cryptico.b64to256(aes_iv_b64))
                        console.log "key: #{aes_key}"
                        console.log "iv: #{aes_iv}"                        
                        encrypted_data=$.parseJSON(ajaxOptions.data)
                        encrypted_data.key_session_id=aes_info.key_session_id
                        fields=['login','password','name','email']
                        for field in fields
                                encrypted_data.user[field]=cryptico.encryptAESCBC_ruby_compatible(encrypted_data.user[field],aes_key,aes_iv) if encrypted_data.user?[field]?

                        ajaxOptions.data=JSON.stringify encrypted_data
                        $.ajax(ajaxOptions)


                ).fail (jqXHR, textStatus)->
                        if ajaxOptions.error?
                                ajaxOptions.error(jqXHR, 'Failed to obtain AES key.')
                        


