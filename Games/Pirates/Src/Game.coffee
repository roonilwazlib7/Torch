Torch.StrictErrors()
Torch.DumpErrors()
Torch.ImportMath()

Pirates = new Torch.Game("container", "fill", "fill", "Pirates", Torch.CANVAS)

Load = (game) ->
    Ship.Load(@)

Init = (game) ->
    ( new Ship(@) )

Draw = (game)->

Update = (game) ->

Pirates.Start
    Load: Load
    Update: Update
    Draw: Draw
    Init: Init

window.Pirates = Pirates
