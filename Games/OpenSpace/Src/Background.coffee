exports = this
class exports.Background
    constructor: (game) ->
        @mainBackground = new MainBackground(game)
        @secondaryBackground = new SecondaryBackground(@mainBackground)

        @mainBackground.drawIndex = @secondaryBackground.drawIndex = -1000

    Trash: ->
        @mainBackground.Trash()
        @secondaryBackground.Trash()

class MainBackground extends Torch.Sprite
    constructor: (game) ->
        super( game, 0, 0 )

        @Bind.Texture( "background" )
        @Body.velocity.y = 0.6

    Update: ->
        super()

        if @position.y >= @rectangle.height
            @position.y = 0

class SecondaryBackground extends Torch.Sprite
    constructor: (@mainBackground) ->
        super( @mainBackground.game, 0, 0 )

        @Bind.Texture( "background" )

    Update: ->
        super()

        @position.Set( 0, @mainBackground.position.y - @rectangle.height )
