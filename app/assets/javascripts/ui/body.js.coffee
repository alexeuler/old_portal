namespace 'UI', (exports)->
        exports.Body=(animaElement, dataElement) ->
                dataElement.on 'click', 'a', (e) ->
                        e.preventDefault()
                        ref=$(this).attr('href')
                        window.location.hash=ref
                dataElement.on 'click', 'input[type="submit"]', (e) ->
                        e.preventDefault()
                        UI.LoadElement animaElement, dataElement, ParseForm($(this).closest('form')), new UI.Infra.Animation().Fade()

