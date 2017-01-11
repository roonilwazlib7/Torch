TorchModule class Texture
    image: null
    drawParams: null
    width: 0
    height: 0

    constructor: (@image) ->
        @width = @image.width
        @height = @image.height
        @drawParams = new DrawParams(@width, @height)

class DrawParams
    clipX: 0
    clipY: 0
    clipWidth: 0
    clipHeight: 0

    constructor: (@clipWidth, @clipHeight) ->
