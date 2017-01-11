TorchModule class Video
    video: null
    drawParams: null
    width: 0
    height: 0

    constructor: (@video) ->
        @width = @video.videoWidth
        @height = @video.videoHeight

        @drawParams = new DrawParams(@width, @height)

    Play: ->
        @video.play()

        return @

    Stop: ->
        @video.stop()

        return @

    Loop: (turnOn = true)->
        @video.loop = turnOn

        return @
