namespace 'UI', (exports) ->
        exports.LoginDialog = (modalContainer, load_from_url, callback) ->
                modalContainer.modal('show')
                modalBody=modalContainer.find('.modal-body')
                modalBody
                .load(load_from_url)
                .off('click')
                .on 'click', 'a:not(.social)', (e)->
                        e.preventDefault()
                        e.stopPropagation()
                        modalContainer.removeClass('fade')
                        UI.LoadElement modalContainer, modalBody, $(this).attr('href'), new UI.Infra.Animation().Fade(), -> modalContainer.addClass('fade')
                .on 'click', 'input[type="submit"]', (e) ->
                        button=$(this)
                        e.preventDefault()
                        ajaxOptions=ParseForm($('.modal-body').find('form'))
                        ajaxOptions.error=(jqXHR, textStatus)->
                                button.removeAttr('disabled')
                                UI.Infra.ShowError(jqXHR.responseText, modalBody.find('.modal-innerbody'))
                        ajaxOptions.success=(data, textStatus, jqXHR)->
                                #if no errors in response
                                if $(data).find('#errorExplanation').length > 0
                                        modalBody.html(data)
                                else
                                        modalContainer.modal('hide')
                                        #renew body to update rights, i.e. can edit now
                                        hash=window.location.hash.substr(1)
                                        UI.LoadElement  $('.body_container'), $('.body'), hash, new UI.Infra.Animation().Fade()
                                        callback?()
                        button.attr('disabled','')
                        Security.SendSecurePassword(ajaxOptions)

                
namespace 'UI', (exports) ->        
        exports.LoginPanel = (loginPanel) ->
                loginPanel.on 'click', 'a.login_link', (e) ->
                        e.preventDefault()
                        e.stopPropagation()
                        UI.LoginDialog $('#myModal'),$(this).attr('href'), ->
                                $.ajax('/login_panel/show')
                                .done (data, textStatus, jqXHR)->
                                        loginPanel.html($(data).children())

                                


                
