exports = this

class exports.Ship extends Torch.Sprite
    VELOCITY: 0.4
    # static load method
    @Load: (game) ->
        game.Load.DefinePathShortCut("@ships", "Assets/PNG/Retina/Ships")
        game.Load.Texture("@ships/ship1.png", "ship-1")

    constructor: (@game) ->
        super( @game, 500, 500 )

        @Bind.Texture("ship-1")
        @Body.RotateToVelocity(-Math.D90)

    Update: ->
        super()

        keys = @game.Keys
        vx = 0
        vy = 0

        if keys.D.down then vx = 1
        if keys.A.down then vx = -1
        if keys.S.down then vy = 1
        if keys.W.down then vy = -1

        @Body.velocity.Set(vx * @VELOCITY, vy * @VELOCITY)
