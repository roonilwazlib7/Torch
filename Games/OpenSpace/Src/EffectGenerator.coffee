exports = this
class exports.EffectGenerator
    constructor: (@game) ->

    CreateSimpleExplosion: (x, y) ->
        ex = new SimpleExplosion(@game, x, y)
        return ex

class SimpleExplosion extends Torch.Sprite
    constructor: (game, x, y) ->
        atlas = game.Assets.GetTextureAtlas( "simple-explosion" )
        firstFrame = atlas.textures[ "simpleExplosion00" ]

        super( game, x - firstFrame.width/2, y - firstFrame.height/2 )

        @Size.Scale(2,2)
        @drawIndex = 5000


        @Animations.AtlasFrame( "simple-explosion", "simple-explosion", [
                "simpleExplosion00"
                "simpleExplosion01"
                "simpleExplosion02"
                "simpleExplosion03"
                "simpleExplosion04"
                "simpleExplosion05"
                "simpleExplosion06"
                "simpleExplosion07"
                "simpleExplosion08"
            ], step:40 ).On "Finish", =>
                @Trash()
