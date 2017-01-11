class Player extends Torch.Sprite
    VELOCITY: 0.4
    stoppped: false
    touching: null
    hp: 100
    constructor: (game) ->
        @InitSprite(game, 0, 0)
        @Bind.Texture("player-right-idle")

        @spriteSheetAnim = @Animations.SpriteSheet(16, 16, 2)
        @spriteSheetAnim.Stop()

        @audioPlayer = @game.Audio.CreateAudioPlayer()
        @audioPlayer.volume = 0.25

        @movementStateMachine = @States.CreateStateMachine("Movement")
        @movementStateMachine.AddState("idle", idleState)
        @movementStateMachine.AddState("move", moveState)
        @movementStateMachine.Switch("idle")

        @drawIndex = 11
        @facing = "forward"
        @shootKeyWasDown = false

        # should set boundaries based on maps
        # maps are 24x16

        @game.Camera.JerkFollow @, 5,
            maxLeft: 0
            maxRight: 24 * 16 * 4 # hard coded right now
            maxTop: 0
            maxBottom: 16 * 16 * 4

        # this event still triggers even when sprite is destroyed
        @game.Keys.Space.On "KeyUp", =>
            @audioPlayer.PlaySound("shoot")
            b = new PlayerBullet(@)

        scale = @game.GetScale()
        @Size.Scale(scale, scale)

        @SetUpCollisions()

    @Load: (game) ->
        game.Load.Texture("Assets/Art/player/player-forward-idle.png", "player-forward-idle")
        game.Load.Texture("Assets/Art/player/player-backward-idle.png", "player-backward-idle")
        game.Load.Texture("Assets/Art/player/player-right-idle-sheet.png", "player-right-idle")
        game.Load.Texture("Assets/Art/player/player-left.png", "player-left-idle")

        game.Load.Texture("Assets/Art/player/bullet.png", "player-bullet")
        game.Load.Texture("Assets/Art/player/shoot-particle.png", "shoot-particle")

    Update: ->
        super()

        @Trash() if @health <= 0

    SetUpCollisions: ->
        @Collisions.Monitor()
        @On "Collision", (event) =>
            @HandleCollision(event)

    HandleCollision: (event) ->
        return if not event.collisionData.collider.hardBlock
        @Collisions.SimpleCollisionHandle(event, 0.5)

        if event.collisionData.collider.ENEMY
            @HandleEnemyCollision(event.collisionData.collider)

    HandleEnemyCollision: (enemy) ->
        @hp -= enemy.touchDamage
        @Effects.Flash()


idleState =
    Execute: (player) ->
        if @game.Keys.W.down
            player.facing = "forward"
            @stateMachine.Switch("move", "W", {x: 0, y: -1})
        else if @game.Keys.S.down
            player.facing = "backward"
            @stateMachine.Switch("move", "S", {x: 0, y: 1})
        else if @game.Keys.D.down
            player.facing = "right"
            @stateMachine.Switch("move", "D", {x: 1, y: 0})
        else if @game.Keys.A.down
            player.facing = "left"
            @stateMachine.Switch("move", "A", {x: -1, y: 0})

    Start: (player) ->
        player.Body.velocity.x = 0
        player.Body.velocity.y = 0

    End: (player) ->
        # ...

moveState =
    Execute: (player) ->
        if not @game.Keys[@triggerKey].down
            @stateMachine.Switch("idle")

    Start: (player, key, velocity) ->
        player.spriteSheetAnim.Start()
        player.Body.velocity.y = velocity.y * player.VELOCITY
        player.Body.velocity.x = velocity.x * player.VELOCITY
        @triggerKey = key

        switch player.facing
            when "forward"
                player.Bind.Texture("player-forward-idle")
                player.spriteSheetAnim.SyncFrame()
            when "backward"
                player.Bind.Texture("player-backward-idle")
                player.spriteSheetAnim.SyncFrame()
            when "right"
                player.Bind.Texture("player-right-idle")
                player.spriteSheetAnim.SyncFrame()
            when "left"
                player.Bind.Texture("player-left-idle")
                player.spriteSheetAnim.SyncFrame()

    End: (player) ->
        player.spriteSheetAnim.Stop()
        player.spriteSheetAnim.Index(0)

window.Player = Player
