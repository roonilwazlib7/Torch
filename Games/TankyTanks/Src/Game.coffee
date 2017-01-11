Torch.StrictErrors()
Torch.DumpErrors()

tankyTanks = new Torch.Game("container", "fill", "fill", "TankyTanks", Torch.CANVAS)

Load = (game) ->
    Tank.Load( game )
    Bullet.Load( game )

Init = (game) ->
    game.Clear("purple")
    game.SetBoundaries( 0, 0, game.Camera.Viewport.width, game.Camera.Viewport.height )
    game.testPlayer = new Tank( game, 500, 500 )
    game.testPlayer.GiveControl( new GamePadController_Xbox360( game.GamePads.Pad(0) ) )
    game.dText = game.Factory.Text 10, 10,
        text: ""
        color: "black"
        fontSize: 18
        font: "monospace"


Draw = (game)->

Update = (game) ->
    pad = game.GamePads.Pad(0)

    if pad?
        game.dText.text = """
        RightX: #{ pad.sticks.RightStick.horizontalAxis };
        RightY: #{ pad.sticks.RightStick.verticalAxis };
        TankRotation: #{ game.testPlayer.rotation };
        BarrelRotation: #{ game.testPlayer.barrel.rotation };
        """


tankyTanks.Start
    Load: Load
    Update: Update
    Draw: Draw
    Init: Init

window.tankyTanks = tankyTanks
