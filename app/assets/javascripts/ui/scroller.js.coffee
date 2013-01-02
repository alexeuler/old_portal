namespace 'UI', (exports)->
        exports.Scroller= ->

                windowHeight= ->
                        $(window).height()

                scrollableHeight= ->
                        scrollable.outerHeight(true)

                scrollBarHeight= ->
                        windowHeight() / (scrollableHeight() / windowHeight())
                        
                updateScrollerSize= ->
                        container.height(windowHeight())
                        scrollBarContainer.height(windowHeight())
                        scrollBar.height(scrollBarHeight())
                        scrollBar.css {
                                top: -scrollable.position().top*(windowHeight()/scrollableHeight())
                                }


                        
                container=$('.global_container')
                .css('minHeight','0')
                .css('overflow','hidden')

                scrollable=$('.centered_container')

                scrollBarContainer=$('<div class="scroll_bar_container">')
                .css({left:$(window).width()*0.99})
                container.prepend(scrollBarContainer)
                                
                scrollBar=$('<div class="scroll_bar">')
                .draggable({
                        axis:'y'
                        containment:'parent'
                        drag: ->
                                    scrollable.css {
                                        top: -Math.round (scrollBar.position().top/(windowHeight()/scrollableHeight())), 0
                                        }
                })
                .appendTo(scrollBarContainer)


                
                updateScrollerSize()
                $(window).resize(updateScrollerSize)
                
                
                
