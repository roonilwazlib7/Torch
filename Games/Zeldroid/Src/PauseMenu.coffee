#TODO:
# Trigger pause of sprites
# Add a background
# Add resume
# add quit
exports = this
class exports.PauseMenu
    active: false
    constructor: (@game) ->
        @background = new Torch.Shapes.Box(@game, 0, 0, @game.Camera.Viewport.width, @game.Camera.Viewport.height)
        @background.fixed = true
        @background.drawIndex = 2000
        @background.opacity = 0.5
        @background.draw = false

        @game.Keys.Enter.On "KeyUp", =>
            @SwitchMode()

    SwitchMode: ->
        if @active
            Torch.Util.Array(@game.spriteList).All (sprite) ->
                sprite.Pause(false)

            @active = false
            @background.draw = false
        else
            Torch.Util.Array(@game.spriteList).All (sprite) ->
                sprite.Pause()

            @active = true
            @background.draw = true
