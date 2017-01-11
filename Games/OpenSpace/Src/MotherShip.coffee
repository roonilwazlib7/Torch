exports = this

class exports.MotherShip extends Torch.Sprite
    MOTHERSHIP: true
    hp: 500
    maxHp: 500
    constructor: (game) ->
        super( game, 0, 0 )
        @Body.omega = 0.0001
        @Bind.Texture("mothership")
        @Size.Scale(0.5, 0.5)
        @Center()
        @CenterVertical()

        @game.hud.mothershipHealth.maxCharge = @game.hud.mothershipHealth.charge = @hp

        @On "Damaged", (event) =>
            @hp -= event.damage
            @game.hud.mothershipHealth.Deplete( event.damage  )

        @game.On "Lose", =>
            @Trash() # maybe an effect here?


    @Load: (game) ->
        game.Load.Texture("Assets/Art/mothership.png", "mothership")

    Update: ->
        super()

        if @hp <= 0
            @game.State.Switch("lose")
