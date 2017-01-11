exports = this
class exports.HUD
    constructor: (@game) ->
        @scoreText = new Torch.Text @game, 20, 20,
            text: "000"
            fontSize: 28
            font: "main-font"
            color: "white"

        @battery = new BatteryBar(@game)
        @playerHealth = new PlayerHealthBar(@game)
        @mothershipHealth = new MotherShipHealthBar(@game)

        @playerHealth.bar.position.y = 175
        @mothershipHealth.bar.position.y = 250

    @Load: (game) ->
        game.Load.Texture("Assets/Art/battery.png", "battery")
        game.Load.Texture("Assets/Art/cross.png", "player-health")
        game.Load.Texture("Assets/Art/circle.png", "mothership-health")

class Bar
    fullBatteryWidth: 300
    charge: 100
    maxCharge: 100
    iconTextureId: ""
    constructor: (game) ->
        @game = game
        @bar = new Torch.Shapes.Box(game, 20, 100, @fullBatteryWidth, 50, "green", "green")
        @icon = new Torch.Sprite(game, 0, 0)
        @icon.Bind.Texture(@iconTextureId)
        @icon.Size.Scale(1,1)
        @icon.Grid.CenterVertical()
        @icon.Grid.margin.left = 10

        @bar.Grid.Append(@icon)

    SetColor: ->
        percentCharge = (@charge / @maxCharge) * 100

        if percentCharge > 80
            @bar.fillColor = @bar.strokeColor = "green"
            return

        if percentCharge <= 75
            @bar.fillColor = @bar.strokeColor = "yellow"

        if percentCharge <= 50
            @bar.fillColor = @bar.strokeColor = "orange"

        if percentCharge <= 25
            @bar.fillColor = @bar.strokeColor = "red"

    Deplete: (percentage) ->
        return if @charge <= 0
        @charge -= percentage

        change = @fullBatteryWidth * ( percentage / @maxCharge )
        @bar.width -= change

        @SetColor()

    ReCharge: (amount) ->
        return if @charge >= @maxCharge

        @charge += amount

        if @charge >= @maxCharge
            @charge = @maxCharge

        change = @fullBatteryWidth * (@charge / @maxCharge)
        @SetColor()

        @game.Tweens.Tween( @bar, 300, Torch.Easing.Smooth ).To( width: change )

class BatteryBar extends Bar
    iconTextureId: "battery"

class PlayerHealthBar extends Bar
    iconTextureId: "player-health"

class MotherShipHealthBar extends Bar
    iconTextureId: "mothership-health"
