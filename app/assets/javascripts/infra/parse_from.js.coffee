@ParseForm = (form)->
        ajaxOptions=
                url:form.attr('action')
                type: 'POST'
                contentType: 'application/json; charset=utf-8'
        postData={}
                       
        form.find('input, select').not('input[type="hidden"]').not('input[type="submit"]').not('.combo_edit_box').each (index) ->
                name=$(this).attr('name')
                params=name.split('[')
                for key,value of params
                        params[key]=params[key].replace(']','')
                postData[params[0]]={} unless postData[params[0]]?
                postData[params[0]][params[1]] = $(this).val()
                
        form.find('input[type="hidden"]').each ->
                if $(this).attr('name') is 'authenticity_token' then postData['authenticity_token']=$(this).val()
                if $(this).attr('name') is 'user[reset_password_token]' then postData['user']['reset_password_token']=$(this).val()
                if $(this).attr('name') is '_method' then ajaxOptions.type=$(this).val().toUpperCase()
                        
        ajaxOptions.data=JSON.stringify postData
        ajaxOptions

