namespace 'UI.Infra', (exports) ->
        exports.Animate = (animations, queue) ->
                        (element, callback) ->
                                for anima in animations
                                        anima.options.complete=callback if callback?
                                        anima.options.queue=queue
                                        element.animate anima.properties, anima.options

 namespace 'UI.Infra', (exports) ->
        class exports.Animation
                constructor: (duration) ->
                        @duration=duration ? 500
                Fade: ->
                        inAnimations=[{
                                        properties:
                                                opacity:0
                                        options:
                                                duration:@duration
                                                }]
                        outAnimations=[{
                                        properties:
                                                opacity:1
                                        options:
                                                duration:@duration
                                                }]
                        Anima=
                                In: UI.Infra.Animate(inAnimations),
                                Out: UI.Infra.Animate(outAnimations)
                                
                SlideLeft: (slide=200,final=0) ->
                        inAnimations=[{
                                        properties:
                                                left:'-='+slide.toString()
                                                opacity:0
                                        options:
                                                duration:@duration
                                                }]
                        outAnimations=[{
                                        properties:
                                                left:'+='+(2*slide).toString()
                                        options:
                                                duration:0
                                                },{
                                        properties:
                                                left:final
                                                opacity:1                                                
                                        options:
                                                duration:@duration
                                                        }]
                        Anima=
                                In: UI.Infra.Animate(inAnimations),
                                Out: UI.Infra.Animate(outAnimations)
                                
                SlideRight: (slide=200,final=0) ->
                        inAnimations=[{
                                        properties:
                                                left:'+='+slide.toString()
                                                opacity:0
                                        options:
                                                duration:@duration
                                                }]
                        outAnimations=[{
                                        properties:
                                                left:'-='+(2*slide).toString()
                                        options:
                                                duration:0
                                                },{
                                        properties:
                                                left:final
                                                opacity:1                                                
                                        options:
                                                duration:@duration
                                                        }]
                        Anima=
                                In: UI.Infra.Animate(inAnimations),
                                Out: UI.Infra.Animate(outAnimations)
                        
                AppearFromTop: (top=200) ->
                        inAnimations=[{
                                        properties:
                                                top:'-='+top*1.2
                                                opacity:0
                                        options:
                                                duration:@duration
                                                }]
                        outAnimations=[{
                                        properties:
                                                top:top
                                                opacity:1                                                
                                        options:
                                                duration:@duration
                                                        }]
                        Anima=
                                In: UI.Infra.Animate(inAnimations),
                                Out: UI.Infra.Animate(outAnimations)
                        