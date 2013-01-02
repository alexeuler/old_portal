namespace 'UI', (exports) ->
        exports.LoadElement =(animaElement, dataElement, ajaxOpts,anima,callbackOut,callbackIn) ->
                        waitingAnimation=false
                        waitingAjax=false
                        ajaxData={}
                        
                        animaSuccess = ->
                                waitingAnimation=false
                                if callbackIn? then callbackIn()
                                loadComplete()
                                
                        ajaxSuccess = (data, textStatus, jqXHR) ->
                                waitingAjax=false
                                ajaxData=data
                                if ajaxData[0..'redirect'.length-1] is 'redirect'
                                        ref=ajaxData.split(" ")[1]
                                        SetHashChange(->)
                                        window.location.hash=ref
                                        waitingAjax=true
                                        $.ajax(ref)
                                        .done(ajaxSuccess)
                                        .error(ajaxError)
                                else
                                       loadComplete()
                                
                        ajaxError = (jqXHR, textStatus, errorThrown) ->
                                waitingAjax=false
                                ajaxData='Error:'+errorThrown.toString()
                                loadComplete()
                                
                        loadComplete = ->
                                unless waitingAnimation or waitingAjax
                                        dataElement.html(ajaxData)
                                        anima.Out?(animaElement,callbackOut)
                                        UI.UpdateUI(dataElement)
                                                
                        waitingAnimation=true
                        waitingAjax=true
                        if anima.In?
                                anima.In(animaElement,animaSuccess)
                        else
                                animaSuccess()
                        $.ajax(ajaxOpts)
                         .done(ajaxSuccess)
                        .fail(ajaxError)
