namespace 'UI.Infra', (exports)->
        exports.ScrollToTop = (top=290,threshold=290,duration=0)->
                if $('body').scrollTop()>threshold then $('body').animate({scrollTop:top},duration);

                        