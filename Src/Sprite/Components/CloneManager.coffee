class CloneManager
    sprite: null # the sprite to be cloned

    constructor: (@sprite) ->

    _defaultClone: (keepGame) ->
        clone = {}
        for key,value of @sprite
            continue if key is "game"

            if Util.Type( value ) is "object"
                value = Object.create( value )

            clone[ key ] = value

        @sprite.game.Add( clone ) if keepGame
        return clone

    WithConstructor: (args...) ->
        if not @sprite.constructor?
            throw new Error("Unable to clone with constructor: sprite has no constructor")

        SpriteConstructor = @sprite.constructor

        return new SpriteConstructor( args... )

    WithGame: (keepGame = false) ->
        return @_defaultClone(keepGame)
