exports = this

class Controller extends Torch.GameThing
    tank: null
    timestamp_bulletFired: 0
    moveRight: false
    moveLeft: false
    moveUp: false
    moveDown: false
    moving: false

    constructor: (@game) ->

    Update: ->
        @UpdateMovement()
        @UpdateBarrel()
        @UpdateShooting()

    UpdateBarrel: -> throw new Error( "Controllers must update movement" )

    UpdateBarrel: -> throw new Error( "Controllers must update the barrel" )

    UpdateShooting: -> throw new Error( "Controllers must update shooting" )

class exports.KeyBoardController extends Controller

    UpdateMovement: ->
        keys = @game.Keys

        @moveRight = keys.D.down
        @moveLeft = keys.A.down
        @moveUp = keys.W.down
        @moveDown = keys.S.down

        @moving = ( @moveRight or @moveLeft or @moveUp or @moveDown )

    UpdateBarrel: ->
        v = @tank.barrel.position.Clone()
        v.x += @tank.barrel.rectangle.width / 2
        v.y += @tank.barrel.rectangle.height /2

        m = new Torch.Vector( @game.Mouse.x, @game.Mouse.y )

        v.SubtractVector( m )
        v.Normalize()
        @tank.barrel.rotation = -v.angle


class exports.GamePadController_Xbox360 extends Controller
    constructor: (@gamePad) ->

    UpdateMovement: ->
        buttons = @gamePad.buttons
        sticks = @gamePad.sticks
        rotation = @tank.rotation

        @tank.Body.velocity.Set( sticks.LeftStick.horizontalAxis, sticks.LeftStick.verticalAxis )
        @tank.Body.velocity.MultiplyScalar( @tank.moveSpeed )

        if @tank.Body.velocity.magnitude > 0
            rotation = @tank.Body.velocity.angle + Math.PI / 2

        @tank.rotation = rotation

    UpdateBarrel: ->
        rotation = @tank.barrel.rotation

        if Math.abs(@gamePad.sticks.RightStick.verticalAxis) > 0 or Math.abs(@gamePad.sticks.RightStick.horizontalAxis) > 0
            rotation = Math.atan2( @gamePad.sticks.RightStick.verticalAxis, @gamePad.sticks.RightStick.horizontalAxis )
            rotation += Math.PI / 2

        @tank.barrel.rotation = rotation

    UpdateShooting: ->
        game = @tank.game
        if @gamePad.buttons.RightTrigger.down and ( game.time - @timestamp_bulletFired ) > 400
            @timestamp_bulletFired = game.time
            @tank.Shoot()
