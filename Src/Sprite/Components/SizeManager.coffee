class SizeManager
    width: 0
    height: 0
    scale: null

    constructor: (@sprite) ->
        rect = @sprite.rectangle
        @width = rect.width
        @height = rect.height
        @scale = {width: 1, height: 1}

    Update: ->
        rect = @sprite.rectangle

        if @sprite.torch_shape
            rect.width = @sprite.width
            rect.height = @sprite.height

    Set: (width, height) ->
        @width = @sprite.rectangle.width = width * @scale.width
        @height = @sprite.rectangle.height = height * @scale.height

    Scale: (widthScale, heightScale) ->
        rect = @sprite.rectangle

        @scale.width = widthScale
        @scale.height = heightScale

        rect.width = @width * @scale.width
        rect.height = @height * @scale.height
