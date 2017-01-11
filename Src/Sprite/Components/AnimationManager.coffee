class Animation extends Trashable
    @MixIn Trashable
    @MixIn EventDispatcher

    loop: false
    stopped: false
    intervalTime: 0
    stepTime: 0
    constructor: ->
        @InitEventDispatch()

    Loop: ->
        @loop = true
        return @


class AnimationManager
    animations: null
    constructor: (@sprite) ->
        @animations = []

    Update: ->
        cleanedAnims = []
        for anim in @animations
            anim.Update()
            cleanedAnims.push(anim) if not anim.trash
        @animations = cleanedAnims

    SpriteSheet: (width, height, numberOfFrames, config = {step: 200}) ->
        anim = new SpriteSheetAnimation(@sprite, width, height, numberOfFrames, config.step)
        @animations.push( anim )
        return anim

    AtlasFrame: (atlasId, textureId, frames, config = {step: 200}) ->
        anim = new AtlasFrameAnimation(@sprite, atlasId, textureId, frames, config.step)
        @animations.push( anim )
        return anim

class SpriteSheetAnimation extends Animation
    index: -1
    clipX: 0
    clipY: 0
    game: null
    clipWidth: null
    clipHeight: null
    numberOfFrames: null
    stepTime: null

    constructor: (@sprite, @clipWidth, @clipHeight, @numberOfFrames, @stepTime) ->
        super()
        @loop = true
        @game = @sprite.game
        @Reset()

    Update: ->
        return if @stopped
        @intervalTime += @game.Loop.updateDelta

        if @intervalTime >= @stepTime
            @AdvanceFrame()

    AdvanceFrame: ->
        @intervalTime = 0
        @index += 1

        @sprite.texture.drawParams.clipX = @index * @clipWidth

        if @index >= @numberOfFrames - 1

            if @loop
                @index = -1
            else
                @Trash()

    Stop: ->
        @stopped = true

    Start: ->
        @stopped = false

    Index: (index) ->
        @index = index - 1
        @sprite.texture.drawParams.clipX = ( @index + 1) * @clipWidth

    Reset: ->
        @intervalTime = 0
        @index = -1

        @sprite.texture.drawParams.clipX = 0
        @sprite.texture.drawParams.clipY = 0
        @sprite.texture.drawParams.clipWidth = @clipWidth
        @sprite.texture.drawParams.clipHeight = @clipHeight
        @sprite.Size.width = @clipWidth
        @sprite.Size.height = @clipHeight

    SyncFrame: ->
        @sprite.texture.drawParams.clipX = 0
        @sprite.texture.drawParams.clipY = 0
        @sprite.texture.drawParams.clipWidth = @clipWidth
        @sprite.texture.drawParams.clipHeight = @clipHeight
        @sprite.Size.width = @clipWidth
        @sprite.Size.height = @clipHeight

class AtlasFrameAnimation extends Animation
    index: 0
    constructor: (@sprite, @atlasId, @textureId, @frames, @stepTime) ->
        super()
        @game = @sprite.game
        @numberOfFrames = @frames.length

    Update: ->
        return if @stopped
        @intervalTime += @game.Loop.updateDelta

        if @intervalTime >= @stepTime
            @AdvanceFrame()

    AdvanceFrame: ->
        @intervalTime = 0
        @index += 1

        @sprite.Bind.Atlas( @atlasId, @textureId, @frames[@index] )

        if @index >= @numberOfFrames - 1

            if @loop
                @index = 0
            else
                @Emit "Finish", new Torch.Event(@game, {animation: @})
                @Trash()
