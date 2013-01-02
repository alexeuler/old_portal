class this.Utils
        this.UnpackString=(str)->
                bytes=[]
                for i in [0...str.length]
                        bytes.push str.charCodeAt(i)
                bytes
