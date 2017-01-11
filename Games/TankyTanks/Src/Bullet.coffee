exports = this

class exports.Bullet extends Torch.Sprite
    shooter: null # the tank that shot the bullet
    shootDist: 100
    constructor: ( @shooter ) ->
        super( @shooter.game, @shooter.barrel.shootPoint.position.x, @shooter.barrel.shootPoint.position.y )

        @Bind.Texture( "bullet-silver" )

        @rotationOffset.y = -1 * @rectangle.height
        @rotation = @shooter.barrel.rotation
        if not @rotation? then @rotation = 0

        rot = @rotation - Math.PI / 2
        vX = Math.cos( rot )
        vY = Math.sin( rot )

        @Body.velocity.Set(vX, vY)
        @position.x -= ( @rectangle.width / 2 )
        @position.y -= ( @rectangle.height / 2 )

        @On "OutOfBounds", =>
            @Body.velocity.MultiplyScalar(-1)


    @Load: (game) ->
        game.Load.Texture( "Assets/Art/PNG/Bullets/bulletSilver_outline.png", "bullet-silver" )
