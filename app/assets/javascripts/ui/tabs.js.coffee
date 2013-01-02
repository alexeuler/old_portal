namespace 'UI', (exports)->
        exports.Tabs=(element, bodyAnimaElement, bodyDataElement) ->
                tabsSliderAnimate = (fromId, toId)->
                        aOptions=
                                duration:500
                                queue:false
                                easing:'linear'
                                complete:->
                                        element.find('li#'+toId+' a').addClass('selected')
                                        selectedTo.removeClass('pre_selected')
                                        slider.remove()
                        selectedFrom=element.find 'li#'+fromId+' a'
                        leftFrom=Math.round selectedFrom.position().left
                        selectedTo=element.find 'li#'+toId+' a'
                        leftTo=Math.round selectedTo.position().left

                        slider=selectedFrom.clone().appendTo(element)
                        slider.children('span').html('&nbsp')

                        selectedFrom.removeClass('selected');
                        selectedTo.addClass('pre_selected')

                        slider.attr('style','z-index:1; position:absolute; left:'+leftFrom+'px');
                        slider.animate {left:leftTo},aOptions

#Init starts here                                                
                element.on 'click', 'a.tabs_button', (e)->
                        e.preventDefault()
                        fromId=element.find('li:has(a.selected)').attr('id')
                        toId=$(this).closest('li').attr('id')
                        tabsSliderAnimate fromId, toId
                        ref=$(this).attr('href')
                        
                        anima=null
                        if toId>fromId
                                anima=new UI.Infra.Animation().SlideLeft()
                        else
                                anima=new UI.Infra.Animation().SlideRight()
                        SetHashChange ->
                                UI.LoadElement(bodyAnimaElement, bodyDataElement, ref, anima)
                        window.location.hash=ref        