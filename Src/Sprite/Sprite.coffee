TorchModule class Sprite extends GameThing
    Sprite.MixIn(EventDispatcher)

    torch_render_type: "Image"
    torch_type: "Sprite"

    constructor: (game, x, y)->
        @InitSprite(game, x, y)

    InitSprite: (game, x = 0, y = 0)->

        # check the argument types
        gameType = Util.Type(game)
        xType = Util.Type(x)
        yType = Util.Type(y)

        if not game? or gameType isnt "Game"
            throw new ER.ArgumentError("game", game, ["Torch.Game"])

        if xType isnt "number"
            throw new ER.ArgumentError("x", x, ["number"])

        if yType isnt "number"
            throw new ER.ArgumentError("y", y, ["number"])

        @InitEventDispatch()

        @game = game

        @rectangle = new Rectangle(x, y, 0, 0)
        @position = new Vector(x,y)
        @rotationOffset = new Vector( 0, 0 )

        @Bind = new BindManager(@)
        @Collisions = new CollisionManager(@)
        @Body = new BodyManager(@)
        @Size = new SizeManager(@)
        @Events = new EventManager(@)
        @Effects = new EffectManager(@)
        @States = new StateMachineManager(@)
        @Grid = new GridManager(@)
        @Animations = new AnimationManager(@)
        @Clone = new CloneManager(@)

        @texture = null
        @video = null

        @fixed = false
        @draw = true
        @paused = false

        @drawIndex = 0
        @rotation = 0
        @opacity = 1

        @_torch_add = "Sprite"
        @_torch_uid = ""

        @events = {}
        @renderer = new CanvasRenderer(@)

        @exportValues = []

        game.Add(@)

    UpdateSprite: ->
        return if @paused
        @rectangle.x = @position.x
        @rectangle.y = @position.y
        @Body.Update()
        @Size.Update()
        @Events.Update()
        @States.Update()
        @Grid.Update()
        @Animations.Update()
        @Effects.Update()
        @Collisions.Update() # this needs to be after the rectangle thing, God knows why

        if @game.boundary and not @rectangle.Intersects( @game.boundary )
            @Emit "OutOfBounds", new Event( @game, { sprite: @ } )

    Update: ->
        @UpdateSprite()

    Draw: ->
        @renderer.Draw()

    NotSelf: (otherSprite) ->
        return (otherSprite.torch_uid isnt @torch_uid)

    Wrap: ->
        @On "OutOfBounds", =>
            return if not @game.boundary

            if @position.y < @game.boundary.y
                @position.y = @game.boundary.height - @rectangle.height

            if @position.y > @game.boundary.height
                @position.y = @game.boundary.y + @rectangle.height

            if @position.x > @game.boundary.width
                @position.x = @game.boundary.x + @rectangle.width

            if @position.x < @game.boundary.x
                @position.x = @game.boundary.width - @rectangle.width

    Clone: ->
        return Object.create( @ )

    Center: ->
        width = @game.canvasNode.width
        x = (width / 2) - (@rectangle.width/2)
        @position.x = x
        return @

    CenterVertical: ->
        height = @game.canvasNode.height
        y = (height / 2) - (@rectangle.height/2)
        @position.y = y
        return @

    CollidesWith: (otherSprite) ->
        return new CollisionDetector(@, otherSprite)

    Pause: (shouldPause = true) ->
        # prevents the sprite from updating
        @paused = shouldPause

    Export: (attribsToExport...) ->
        @exportValues = attribsToExport
