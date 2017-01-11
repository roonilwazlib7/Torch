exports = this
class exports.Projectile extends Torch.Sprite
    PROJECTILE: true
    velocity: 0.5
    flags: null
    forms: null
    shooter: null
    damage: 1
    textureName: "bullet-default"
    constructor: (shooter, config = {}) ->
        @shooter = shooter
        defaultConfig =
            x: shooter.position.x
            y: shooter.position.y
            direction: new Torch.Vector(0,0)
            texture: @textureName

        Torch.Util.Object( defaultConfig ).Extend( config )

        super( shooter.game, defaultConfig.x, defaultConfig.y )

        @flags = [ "projectile" ]

        @Bind.Texture(defaultConfig.texture)
        @Size.Scale(1,1)

        @Body.velocity.Set( defaultConfig.direction.x * @velocity, defaultConfig.direction.y * @velocity )

        @rotation = shooter.rotation

        @SetUpCollisions()

    @Load: (game) ->
        game.Load.Texture("Assets/Art/PNG/Lasers/laserBlue04.png", "bullet-default")
        game.Load.Texture("Assets/Art/PNG/Lasers/laserBlue09.png", "bullet-default-explode")

        game.Load.Texture("Assets/Art/PNG/Lasers/laserRed04.png", "bullet-shooter-enemy")
        game.Load.Texture("Assets/Art/PNG/Lasers/laserRed09.png", "bullet-shooter-enemy-explode")

    Update: ->
        super()
        if not @rectangle.Intersects( @game.Camera.Viewport.rectangle )
            @Trash()

    Kill: ->
        @emitter = @game.Particles.ParticleEmitter 500, 0, 0, true, @textureName + "-explode",
            spread: 20
            gravity: 0.0001
            minAngle: 0
            maxAngle: Math.PI * 2
            minScale: 0.01
            maxScale: 0.05
            minVelocity: 0.01
            maxVelocity: 0.01
            minAlphaDecay: 400
            maxAlphaDecay: 450
            minOmega: 0.001
            maxOmega: 0.001
        @emitter.auto = false
        @emitter.position = @position.Clone()
        @Trash()
        @emitter.EmitParticles(true)

    SetUpCollisions: ->
        @Collisions.Monitor()
        @On "Collision", (event) =>
            obj = event.collisionData.collider

            return if not obj.NotSelf(@shooter) or obj.PROJECTILE
            return if not ( obj.PLAYER or obj.ENEMY or obj.MOTHERSHIP )
            return if ( obj.MOTHERSHIP && @shooter.PLAYER)

            if obj.Emit?
                obj.Emit( "Damaged", damage:@damage )

            @Kill()

class exports.ShooterEnemyProjectile extends exports.Projectile
    textureName: "bullet-shooter-enemy"
