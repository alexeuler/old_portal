namespace 'UI.Infra', (exports) ->
        exports.ShowError = (message, container) ->
                panel=container.find('.alert.alert-error')
                if panel.length is 0
                        panel=$('<p>')
                        .addClass('alert')
                        .addClass('alert-error')
                        .prependTo(container)
                panel.html(message)
