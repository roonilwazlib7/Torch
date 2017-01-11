exports = this

class exports.Powerup extends Torch.Sprite
    POWERUP: true
    textureName: ""
    timeToExisit: 5000 # flashes after this
    timeBeforeTrash: 2000
    constructor: (game, x, y) ->
        super( game, x, y )
        @Bind.Texture(@textureName)
        @Size.Scale(1,1)

        @game.Timer.SetFutureEvent @timeToExisit, =>
            @Effects.Blink()

            @game.Timer.SetFutureEvent @timeBeforeTrash, =>
                @Trash()

    @Load: (game) ->
        game.Load.Texture("Assets/Art/PNG/Power-ups/powerupGreen_bolt.png", "powerup-battery")
        game.Load.Texture("Assets/Art/PNG/Power-ups/powerupGreen_shield.png", "powerup-shield")
        game.Load.Texture("Assets/Art/PNG/Power-ups/pill_green.png", "powerup-life")
        game.Load.Texture("Assets/Art/PNG/Power-ups/PowerupRed_star.png", "powerup-laser")

    ApplyEffect: (player) ->
        # should be overriden by descendent powerups
        @game.audioPlayer.PlaySound("powerup-1")
        @Trash()

class exports.PowerupGenerator
    constructor: (@enemy) ->
        @powerUpPool = new Torch.Util.Math.RandomPool()

        @powerUpPool.AddChoice(BatteryPowerup, 50)
        @powerUpPool.AddChoice(LifePowerup, 50)

    Generate: ->
        powerUp = @powerUpPool.Pick()
        return new powerUp( @enemy.game, @enemy.position.x, @enemy.position.y )

class BatteryPowerup extends exports.Powerup
    textureName: "powerup-battery"

    ApplyEffect: (player) ->
        super()
        @game.hud.battery.ReCharge(10)

class LifePowerup extends exports.Powerup
    textureName: "powerup-life"

    ApplyEffect: (player) ->
        super()
        @game.hud.playerHealth.ReCharge(10)
        player.hp += 10

class LaserPowerup extends exports.Powerup
    textureName: "powerup-laser"

    ApplyEffect: (player) ->
        super()

class ShieldPowerup extends exports.Powerup
    textureName: "powerup-shield"

    ApplyEffect: (player) ->
        super()
