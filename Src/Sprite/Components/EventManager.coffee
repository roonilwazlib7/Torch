SpriteQuery = Util.Enum("RayCast", "CircleCast", "PolygonCast", "RectangleCast")
class EventManager
    mouseOver: false
    clickTrigger: false
    clickAwayTrigger: false
    draw: true
    wasClicked: false

    constructor: (@sprite) ->
        @game = @sprite.game

        @game.On "SpriteQuery", (event) =>
            @HandleQuery( event )

    Update: ->
        if not @game.Mouse.GetRectangle().Intersects(@sprite.rectangle) and @mouseOver
            @mouseOver = false
            @sprite.Emit("MouseLeave", new Torch.Event(@game, {sprite: @sprite}))

        if @game.Mouse.GetRectangle().Intersects(@sprite.rectangle)
            if not @mouseOver
                @sprite.Emit("MouseOver", new Torch.Event(@game, {sprite: @sprite}))
            @mouseOver = true

        else if @sprite.fixed
            mouseRec = @game.Mouse.GetRectangle()
            reComputedMouseRec = new Rectangle(mouseRec.x, mouseRec.y, mouseRec.width, mouseRec.height)
            reComputedMouseRec.x += @game.Camera.position.x
            reComputedMouseRec.y += @game.Camera.position.y
            if reComputedMouseRec.Intersects(@sprite.rectangle)
                @mouseOver = true
            else
                @mouseOver = false
        else
            @mouseOver = false

        if @mouseOver and @game.Mouse.down and not @clickTrigger
            @clickTrigger = true
            @sprite.Emit "MouseDown", new Torch.Event( @game, sprite: @sprite )

        if @clickTrigger and not @game.Mouse.down and @mouseOver
            @wasClicked = true

            @sprite.Emit "MouseUp", new Torch.Event( @game, {sprite: @sprite} )
            @sprite.Emit "Click", new Torch.Event( @game, {sprite: @sprite} )

            @clickTrigger = false

        if @clickTrigger and not @game.Mouse.down and not @mouseOver
            @clickTrigger = false

        if not @game.Mouse.down and not @mouseOver and @clickAwayTrigger
            @sprite.Emit("ClickAway", new Torch.Event(@game, {sprite: @sprite}))
            @wasClicked = false
            @clickAwayTrigger = false

        else if @clickTrigger and not @game.Mouse.down and @mouseOver
            @clickAwayTrigger = false

        else if @game.Mouse.down and not @mouseOver
            @clickAwayTrigger = true

    HandleQuery: (event) ->
        res = null

        res = event.query( @sprite, event.args... )

        if res? and res.valid
            event.results.push( res )
