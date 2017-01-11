exports = this

class exports.PlayerBullet extends Torch.Sprite
    DAMAGE: 1
    constructor: (shooter) ->
        @InitSprite(shooter.game, shooter.position.x, shooter.position.y)
        @Bind.Texture("player-bullet")
        @drawIndex = shooter.drawIndex + 1
        @shooter = shooter
        @VELOCITY = 1.5
        switch shooter.facing
            when "forward"
                @Body.velocity.y = -1 * @VELOCITY
                @position.y -= 0.3 * shooter.rectangle.height
                @position.x += 0.1 * shooter.rectangle.width
            when "backward"
                @Body.velocity.y = 1 * @VELOCITY
                @position.x += 0.1 * shooter.rectangle.width
                @position.y += 0.3 * shooter.rectangle.height
            when "right"
                @Body.velocity.x = 1 * @VELOCITY
                @position.x += 1.1 * shooter.rectangle.width
                @position.y += 0.25 * shooter.rectangle.height
                @rotation = Math.PI/2
            when "left"
                @Body.velocity.x = -1 * @VELOCITY
                @position.x -= 0.1 * shooter.rectangle.width
                @position.y += 0.25 * shooter.rectangle.height
                @rotation = Math.PI/2

        @Size.Scale(10, 10)

        @emitter = @game.Particles.ParticleEmitter 500, 500, 500, true, "shoot-particle",
            spread: 20
            gravity: 0.0001
            minAngle: 0
            maxAngle: Math.PI * 2
            minScale: 2
            maxScale: 4
            minVelocity: 0.01
            maxVelocity: 0.01
            minAlphaDecay: 200
            maxAlphaDecay: 250
            minOmega: 0.001
            maxOmega: 0.001
        @emitter.auto = false
        @emitter.position = @position.Clone()
        @emitter.EmitParticles(true)

        @Collisions.Monitor()
        @On "Collision", (event) =>
            return if not event.collisionData.collider.hardBlock

            event.collisionData.collider.BulletHit(@)

            @Trash()

            @emitter.particle = "particle"
            @emitter.position = @position.Clone()
            @emitter.EmitParticles(true)
            @shooter.audioPlayer.PlaySound("shoot-explode")


    Update: ->
        super()
        if @Body.distance >= 500
            @Trash()
