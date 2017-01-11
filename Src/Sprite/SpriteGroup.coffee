TorchModule class SpriteGroup extends GameThing
    @MixIn EventDispatcher

    sprites: null
    position: null
    constructor: (@game, x, y) ->
        @InitEventDispatch()
        @game.Add(@)
        @sprites = []
        @position = new Vector(x,y)

    Update: ->
        filtered = []
        for sprite in @sprites
            filtered.push( sprite ) if not sprite.trash

        @sprites = filtered

        if filtered.length <= 0
            @Emit "Empty", new Event(@game, {spriteGroup: @} )

    Every: (calback) ->
        for sprite in @sprites
            calback(sprite)

    Grid: (spriteToCopy, rows, columns, padding = 0) ->
        # TODO
        # support cloning sprites
        # support different widths/heights
        distribution = null
        if Util.Type(spriteToCopy) isnt "array"
            first = new spriteToCopy( @game, @position.x, @position.y )
        else
            distribution = spriteToCopy
            first = new distribution[0]( @game, @position.x, @position.y )

        width = first.rectangle.width
        height = first.rectangle.height

        first.Trash() # this is iffy
        width += padding
        height += padding

        i = 0
        while i < rows

            j = 0
            while j < columns
                if distribution is null
                    copy = new spriteToCopy( @game, @position.x + ( i * width ), @position.y + ( j * height ) )
                else
                    index = Util.Math.RandomInRange(0, distribution.length - 1)
                    index = Math.floor(index)
                    console.log(distribution, index)
                    copy = new distribution[index]( @game, @position.x + ( i * width ), @position.y + ( j * height ) )

                @sprites.push(copy)
                j++

            i++
