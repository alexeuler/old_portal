hashAnimationType='fade'
scrollThreshold=300
scrollTo=200
scrollDuration=500

$(document).ready () ->
        UI.Body $('.body_container'), $('.body')
        UI.Tabs $('.tabs'), $('.body_container'), $('.body')
        UI.LoginPanel $('.login_panel')
        $('#myModal').modal({show:false})

        window.addEventListener "hashchange", (e) ->
                if window.HashChange?
                        window.HashChange(e)
                        window.HashChange=null
                else
                        ref = window.location.hash.substr(1)
                        UI.LoadElement  $('.body_container'), $('.body'), ref, new UI.Infra.Animation().Fade(),null, UI.Infra.ScrollToTop


#Set hash equal to loaded page
        SetHashChange(->)
        path=window.location.pathname
        hash=window.location.hash
        if path is '/'
                if hash.match(/users\/password\/edit/)
                        UI.LoginDialog $('#myModal'), hash.substr(1)
        else
                window.location.hash=path
        
        UI.UpdateUI $('body')




