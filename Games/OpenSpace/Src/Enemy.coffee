exports = this

class exports.Enemy extends Torch.Sprite
    ENEMY: true
    textureName: "enemy-default"
    powerupGenerator: null
    positionTarget: null
    velocity: 0.2
    startVelocity: 0.5
    attackDistance: 500
    hp: 1
    points: 10
    damage: 10
    constructor: (game, x, y) ->
        super( game, x, y )

        @Bind.Texture(@textureName)
        @Size.Scale(1,1)

        dir = @GetMothershipVector()
        dir.MultiplyScalar( @startVelocity )
        @rotation = -dir.angle

        @Body.velocity.Set( dir.x, dir.y )

        @powerupGenerator = new PowerupGenerator(@)
        @mode = @States.CreateStateMachine("Mode")
        @mode.AddState("enter", new EnterState() )
        @mode.AddState("attack", new AttackState() )
        @mode.Switch("enter")

        @On "Damaged", (event) =>
            @hp -= event.damage

    @Load: (game) ->
        game.Load.Texture("Assets/Art/PNG/Enemies/enemyBlack4.png", "enemy-default")
        game.Load.Texture("Assets/Art/PNG/Enemies/enemyGreen4.png", "enemy-diver-2")
        game.Load.Texture("Assets/Art/PNG/Enemies/enemyBlack1.png", "enemy-shooter")
        game.Load.Texture("Assets/Art/PNG/Enemies/enemyGreen1.png", "enemy-shooter-2")

    Kill: ->
        @game.audioPlayer.PlaySound( "explosion-1" )
        @game.effectGenerator.CreateSimpleExplosion( @position.x, @position.y )
        @Trash()

        if Math.random() < 0.3
            @powerupGenerator.Generate()

    Update: ->
        super()
        if @hp <= 0
            @Kill()

            @game.score += 10

    StageAttack: ->
        @Effects.Trail()

    GetMothershipVector: ->
        dir = @position.Clone()
        dir.SubtractVector( @game.motherShip.position )
        dir.MultiplyScalar(-1)
        dir.Normalize()

        return dir

    GetDistanceToMotherShipCenter: ->
        dis = @position.Clone()
        ms = @game.motherShip.position.Clone()

        ms.x += @game.motherShip.rectangle.width / 2
        ms.y += @game.motherShip.rectangle.height / 2

        dis.SubtractVector(ms)

        return dis.magnitude

class exports.DiverEnemy extends exports.Enemy
    startVelocity: 0.2
    attackVelocity: 0.4
    attackDistance: 300
    constructor: (game, x, y) ->
        super( game, x, y )

        @Collisions.Monitor()

        @On "Collision", (event) =>
            obj = event.collisionData.collider

            if obj.MOTHERSHIP
                obj.Emit( "Damaged", damage:@damage )
                @Kill()

    StageAttack: ->
        super()
        @Body.velocity.Normalize()
        @Body.velocity.MultiplyScalar( @attackVelocity )

class exports.ShooterEnemy extends exports.Enemy
    points: 20
    hp: 2
    textureName: "enemy-shooter"

    constructor: (game, x, y) ->
        super( game, x, y )

    Update: ->
        super()

        # roatate at the motherShip
        p = @position.Clone()
        p.SubtractVector( @GetObjectToOrbit().position )

        angle = p.angle - Math.PI
        @rotation = -angle

    GetObjectToOrbit: ->
        return @game.motherShip

    StageAttack: ->
        @orbit = true
        @Effects.Trail()
        @Body.velocity.Set(0,0)
        @Body.Orbit( @GetObjectToOrbit(), 0.001, 400 )

        scheduledEvent = @game.Timer.SetScheduledEvent 300, =>
            p = @position.Clone()
            p.SubtractVector( @GetObjectToOrbit().position )
            p.Normalize()
            p.MultiplyScalar(-1.5)

            rot = @rotation - Math.PI/2
            cordX = Math.cos( rot )
            cordY = Math.sin( rot )

            x = @position.x + ( (@rectangle.width / 2) * cordX ) + @rectangle.width/2
            y = @position.y + ( (@rectangle.height / 2) * cordY ) + @rectangle.height/2

            x -= cordX * @rectangle.width
            y -= cordY * @rectangle.height

            p1 = new ShooterEnemyProjectile @,
                direction: p
                x: x
                y: y

            p1.position.x -= p1.rectangle.width/2
            p1.position.y -= p1.rectangle.height/2

            p1.drawIndex = -1

            @game.audioPlayer.PlaySound("laser-shoot-2")

        @On "Trash", ->
            scheduledEvent.Trash()

class exports.ShooterEnemy2 extends ShooterEnemy
    textureName: "enemy-shooter-2"
    GetObjectToOrbit: ->
        return @game.player

class exports.DiverEnemy2 extends DiverEnemy
    targetObj: null
    attackVelocity: 0.5
    attackDistance: 700
    textureName: "enemy-diver-2"
    StageAttack: ->
        @Effects.Trail()
        @targetObj = @game.player

    Update: ->
        super()

        if @targetObj?
            dir = @position.Clone()
            dir.SubtractVector( @targetObj.position )
            dir.MultiplyScalar(-1)
            dir.Normalize()
            dir.MultiplyScalar( @attackVelocity )
            @rotation = -dir.angle

            @Body.velocity.Set( dir.x, dir.y )


class EnterState
    Execute: (enemy) ->
        if enemy.GetDistanceToMotherShipCenter() <= enemy.attackDistance
            @stateMachine.Switch("attack")

    Start: (enemy) ->

    End: (enemy) ->

class AttackState
    Execute: (enemy) ->

    Start: (enemy) ->
        enemy.StageAttack()

    End: (enemy) ->
