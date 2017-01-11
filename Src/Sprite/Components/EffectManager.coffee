class EffectManager
    tint: null
    mask: null
    effects: null

    constructor: (@sprite) ->
        @effects = []
        @tint = new EffectComponent.Tint()
        @mask = new EffectComponent.Mask()

    Update: ->
        @effects = for effect in @effects
            effect.Update()

            effect if not effect.trash

    Blink: (interval = 300)->
        t = @sprite.game.Tweens.Tween(@sprite, interval, Torch.Easing.Smooth).To( opacity: 0 ).Cycle()
        return t

    Flash: (color = "red", time = 100) ->
        @tint.color = color
        t = @sprite.game.Tweens.Tween( @tint, time, Torch.Easing.Smooth ).From(opacity: 0).To( opacity: 1 )
        t.On "Finish", =>
            t2 = @sprite.game.Tweens.Tween( @tint, time, Torch.Easing.Smooth ).To( opacity: 0 )
            t2.On "Finish", =>
                @tint.color = null
                @tint.opacity = 0.5

    Crumple: (ratio, time) ->

        targetHeight = @sprite.rectangle.height * ratio

        @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( height: targetHeight )

    Stretch: (ratio, time) ->
        targetWidth = @sprite.rectangle.width * ratio

        @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( width: targetWidth )

    Squirt: (point, time) ->
        origWidth = @sprite.rectangle.width
        origHeight = @sprite.rectangle.height

        widthDiff = Math.abs (point.x - @sprite.position.x)
        heightDiff = Math.abs (point.y - @sprite.position.y)

        if widthDiff > 0
            @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( width: widthDiff )

        if heightDiff > 0
            @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( height: heightDiff )

        tween = @sprite.game.Tweens.Tween( @sprite.position, time, Torch.Easing.Smooth ).To( x: point.x, y: point.y )

        tween.On "Finish", =>
            @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( width: origWidth, height: origHeight )

    Trail: () ->
        @effects.push( new TrailEffect(@sprite) )

# a bunch of little effects containers
EffectComponent = {}

class EffectComponent.Tint
    _color: null
    _opacity: 0.5

    @property 'color',
        get: -> return @_color
        set: (value) -> @_color = value

    @property 'opacity',
        get: -> return @_opacity
        set: (value) -> @_opacity = value

class EffectComponent.Mask
    _texture: null
    _in: false
    _out: false
    # destination-in, destination-out
    @property 'texture',
        get: -> return @_texture
        set: (value) -> @_texture = value

    @property 'in',
        get: -> return @_in
        set: (value) -> @_in = value

    @property 'out',
        get: -> return @_out
        set: (value) -> @_out = value

# effects
class TrailEffect
    fadeTime: 200
    constructor: (@sprite) ->

    Update: ->
        t = new Sprite(@sprite.game, @sprite.position.x, @sprite.position.y)
        t.Bind.Texture(@sprite.texture.image)
        t.Size.Scale(1,1)
        t.drawIndex = @sprite.drawIndex - 1
        t.rotation = @sprite.rotation

        @sprite.game.Tweens.Tween( t, @fadeTime, Torch.Easing.Smooth )
        .From( opacity: 0.2 )
        .To( opacity: 0 ).On "Finish", =>
            t.Trash()
