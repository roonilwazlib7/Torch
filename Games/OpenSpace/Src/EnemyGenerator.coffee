exports = this

WaveDirection = Torch.Util.Enum("Left", "Right", "Top", "Bottom")

class exports.EnemyGenerator
    currentEnemyGroup: null
    waves: 0
    constructor: (@game) ->
        @directionPool = new Torch.Util.Math.RandomPool()
        @enemyPool = new Torch.Util.Math.RandomPool()

        @enemyPool.AddChoice(ShooterEnemy, 40)
        @enemyPool.AddChoice(DiverEnemy, 40)
        @enemyPool.AddChoice(ShooterEnemy2, 10)
        @enemyPool.AddChoice(DiverEnemy2, 10)

        @directionPool.AddChoice(WaveDirection.Left, 35)
        @directionPool.AddChoice(WaveDirection.Right, 35)
        @directionPool.AddChoice(WaveDirection.Top, 15)
        @directionPool.AddChoice(WaveDirection.Bottom, 15)

        @Generate()

    GetWave: ->
        @waves += 1
        columns = 1
        rows = 1
        enemy = @enemyPool.Pick()
        direction = @directionPool.Pick()
        l = 500
        switch direction
            when WaveDirection.Left
                direction = new Torch.Vector(-l, l)
            when WaveDirection.Right
                direction = new Torch.Vector(@game.Camera.Viewport.width + l, l)
            when WaveDirection.Top
                direction = new Torch.Vector(l, -l)
            when WaveDirection.Bottom
                direction = new Torch.Vector(l, @game.Camera.Viewport.height + l)

        return [enemy, columns, rows, direction]

    CreateGroup: ->
        @currentEnemyGroup = new Torch.SpriteGroup(@game, 100, -300)

        enemy = null
        rows = null
        columns = null
        direction = null

        @game.Timer.SetScheduledEvent 1500, =>
            [ enemy, columns, rows, direction ] = @GetWave()
            @currentEnemyGroup.position.Set( direction.x, direction.y )
            @currentEnemyGroup.Grid( enemy, columns, rows, 100 )

    Generate: ->
        @CreateGroup()
