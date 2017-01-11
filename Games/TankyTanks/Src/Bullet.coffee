exports = this

class exports.Bullet extends Torch.Sprite
    shooter: null # the tank that shot the bullet
    shootDist: 100
    constructor: ( @shooter ) ->
        super( @shooter.game, @shooter.barrel.shootPoint.position.x, @shooter.barrel.shootPoint.position.y )

        @Bind.Texture( "bullet-silver" )

        @rotation = @shooter.barrel.rotation
        if not @rotation? then @rotation = 0

        rot = @rotation - Math.PI / 2
        vX = Math.cos( rot )
        vY = Math.sin( rot )

        @Body.velocity.Set(vX, vY)
        @Body.velocity.MultiplyScalar(0.3)
        @position.x -= ( @rectangle.width / 2 )
        @position.y -= ( @rectangle.height / 2 )


    Update: ->
        super()
        flippedY = false
        flippedX = false
        if @position.y < 0
            dif =  0 - @position.y
            @position.y = dif
            flippedY = true
        if @position.y > @game.Camera.Viewport.height
            dif = @position.y - @game.Camera.Viewport.height
            @position.y -= dif
            flippedY = true
        if @position.x < 0
            dif = 0 - @position.x
            @position.x = dif
            flippedX = true
        if @position.x > @game.Camera.Viewport.width
            dif = @position.x - @game.Camera.Viewport.width
            flippedX = true

        if flippedY and flippedX
            @Flip()

        else if flippedY then @Flip("y")
        else if flippedX then @Flip("x")

    Flip: (plane = "both")->
        if plane is "both"
            @Body.velocity.Reverse()
        else
            @Body.velocity[ plane ] *= -1

        @Body.velocity.Resolve()
        console.log @rotation
        @rotation = @Body.velocity.angle + Math.PI / 2
        console.log @rotation



    @Load: (game) ->
        game.Load.Texture( "Assets/Art/PNG/Bullets/bulletSilver_outline.png", "bullet-silver" )
