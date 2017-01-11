exports = this

class exports.Tank extends Torch.Sprite
    controller: null          # the object that is controlling the tank
    moveSpeed: 0.2            # the movement velocity of the tank
    barrel: null              # the barrel of the tank

    constructor: ( game, x, y ) ->
        super( game, x, y )

        @Wrap()

        @Bind.Texture( "tank-green" )
        @barrel = new Barrel( @ )



    @Load: (game) ->
        game.Load.Texture("Assets/Art/PNG/Tanks/tankGreen_outline.png", "tank-green")
        game.Load.Texture("Assets/Art/PNG/Tanks/barrelGreen_outline.png", "tank-barrel-green")
        game.Load.Texture("Assets/Art/PNG/Tanks/tracksSmall.png", "track")

    Update: ->
        super()
        if @Body.distance >= ( @rectangle.width * 0.9 )
            t = new Track( @ )
            @Body.distance = 0

    GiveControl: ( controller ) ->
        @controller = controller
        @controller.tank = @
        @game.Add( @controller )

    Shoot: ->
        b = new Bullet( @ )

class Barrel extends Torch.Sprite
    shootDist: 100
    constructor: (@tank) ->
        super( @tank.game, @tank.position.x, @tank.position.y )
        @Bind.Texture( "tank-barrel-green" )

        @rotationOffset.y = -1 * @rectangle.height / 4
        @shootPoint = new Torch.Shapes.Circle(@game, 0, 0, 5, "green", "green")
        @shootDist = @rectangle.width * 2.5

    Update: ->
        super()

        @PositionOnTank()
        rot = @rotation - Math.PI / 2

        x = (@tank.position.x + @tank.rectangle.width/2) + Math.cos( rot ) * @shootDist
        y = (@tank.position.y + @tank.rectangle.height/2) + Math.sin( rot ) * @shootDist

        @shootPoint.position.Set( x, y )

    PositionOnTank: ->
        x = @tank.position.x + ( @tank.rectangle.width / 2 ) - @rectangle.width / 2
        y = @tank.position.y + ( @tank.rectangle.height / 2 ) - @rectangle.height / 2

        @position.Set( x, y )

class Track extends Torch.Sprite
    constructor: (@tank) ->
        super( @tank.game, @tank.position.x, @tank.position.y )

        @Bind.Texture( "track" )

        @rotation = @tank.rotation
        @drawIndex = @tank.drawIndex - 1

        @game.Timer.SetFutureEvent 4000, =>
            @game.Tweens.Tween( @, 1000 ).To( opacity: 0 ).On "Finish", => @Trash()
