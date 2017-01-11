Torch.StrictErrors()
Torch.DumpErrors()

openSpace = new Torch.Game("container", "fill", "fill", "OpenSpace", Torch.CANVAS)

Load = (game) ->
    Player.Load(game)
    Projectile.Load(game)
    Enemy.Load(game)
    HUD.Load(game)
    Powerup.Load(game)
    MotherShip.Load(game)
    MainMenu.Load(game)

    game.Load.Texture("Assets/Art/torch-logo.png", "torch-logo")
    game.Load.Texture("Assets/Art/offon-logo.png", "offon-logo")
    game.Load.Texture("Assets/Art/PNG/UI/cursor.png", "cursor")
    game.Load.Texture("Assets/Art/background.png", "background")
    game.Load.Font("Assets/Art/Bonus/kenvector_future.ttf", "main-font")

    game.Load.TextureAtlas("Assets/Art/Effects/simple-explosion-atlas.json", "simple-explosion")
    game.Load.Texture("Assets/Art/Effects/simple-explosion.png", "simple-explosion")

    #game.Load.Audio("Assets/Audio/background-1.mp3", "background-1")
    game.Load.Audio("Assets/Audio/explosion-1.wav", "explosion-1")
    game.Load.Audio("Assets/Audio/laser-shoot-1.wav", "laser-shoot-1")
    game.Load.Audio("Assets/Audio/laser-shoot-1.wav", "laser-shoot-2")
    game.Load.Audio("Assets/Audio/powerup-1.wav", "powerup-1")

Init = (game) ->
    game.Clear("black")
    game.score = 0
    game.Mouse.SetCursor("cursor")
    game.audioPlayer = game.Audio.CreateAudioPlayer()
    #game.audioPlayer.PlaySound( "background-1" )
    game.audioPlayer.volume = 0

    game.State.AddState "startGame",
        Start: (game) ->
            game.hud = new HUD(game)
            game.background = new Background(game)
            game.motherShip = new MotherShip(game)
            game.player = new Player(game)
            game.enemyGenerator = new EnemyGenerator(game)
            game.debugConsole = new Torch.DebugConsole(game)
            game.effectGenerator = new EffectGenerator(game)
            game.score = 0
        Execute: (game) ->
        End: (game) ->

    game.State.AddState "splash",
        Start: (game) ->
            torchLogo = game.Factory.Sprite(0,0,"torch-logo")
            torchLogo.Center().CenterVertical()

            offAndOnLogo = game.Factory.Sprite(0,0,"offon-logo")
            offAndOnLogo.Center().CenterVertical()

            torchLogo.opacity = 0
            offAndOnLogo.opacity = 0


            # start the sequence
            game.Tweens.Tween(torchLogo, 1000).To(opacity: 1).On "Finish", ->

                game.Timer.SetFutureEvent 5000, ->

                    game.Tweens.Tween(offAndOnLogo, 500).To(opacity: 1).On "Finish", ->

                        game.Timer.SetFutureEvent 5000, ->
                            torchLogo.Trash()
                            offAndOnLogo.Trash()
                            game.State.Switch("mainMenu")

        Execute: (game) ->

        End: (game) ->

    game.State.AddState "mainMenu",
        Start: (game) ->
            game.mainMenu = new MainMenu(game)

        Execute: (game) ->

        End: (game) ->
            game.mainMenu.Trash()

    game.State.AddState "credits",
        Start: (game) ->
            background = new Background(game)
            game.Factory.Text(0,100,
                font: "main-font"
                text: "Programming & Design:"
                color: "purple"
                fontSize: 48).Center()

            game.Factory.Text(0,200,
                font: "main-font"
                text: "Alex Smith (offandongames.io)"
                color: "white"
                fontSize: 24).Center()

            game.Factory.Text(0,300,
                font: "main-font"
                text: "Art:"
                color: "purple"
                fontSize: 48).Center()

            game.Factory.Text(0,400,
                font: "main-font"
                text: "Keeney (keeney.nl)"
                color: "white"
                fontSize: 24).Center()

        Execute: (game) ->
        End: (game) ->

    game.State.AddState "lose",
        Start: (game) ->
            game.Emit( "Lose", {} )

            for thing in game.things
                thing.Trash()

            loseText = new Torch.Text game, 0, 300,
                text: "GAME OVER"
                font: "main-font"
                color: "red"
                fontSize: 48
            loseText.Center()

            restartButton = game.Factory.Button 0, 0,
            {
                color: "white"
                text: "Restart"
                font: "main-font"
                fontSize: 18
            },
            {
                mainBackground: "button-background-red"
                mouseDownBackground: "button-background-mouse-down-red"
            }
            quitButton = game.Factory.Button 0, 600,
            {
                color: "white"
                text: "Quit"
                font: "main-font"
                fontSize: 18
            },
            {
                mainBackground: "button-background-red"
                mouseDownBackground: "button-background-mouse-down-red"
            }
            restartButton.Center().CenterVertical()
            quitButton.Center()

            restartButton.On "Click", ->
                quitButton.Trash()
                loseText.Trash()
                restartButton.Trash()
                game.State.Switch("startGame")

            quitButton.On "Click", ->
                require( 'electron' ).remote.app.quit()

        Execute: (game) ->

        End: (game) ->

    game.State.Switch("startGame")

Draw = (game)->

Update = (game) ->
    if game.hud?
        game.hud.scoreText.text = game.score

openSpace.Start
    Load: Load
    Update: Update
    Draw: Draw
    Init: Init

window.openSpace = openSpace
