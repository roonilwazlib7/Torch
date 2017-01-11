exports = this

class Enemy extends MapPieces.MapPiece
    hardBlock: true
    hp: 3
    ENEMY: true
    touchDamage: 5
    identifier: 200

    @Load: (game) ->
        game.Load.Texture("Assets/Art/enemies/blob.png", "blob")
        game.Load.Texture("Assets/Art/enemies/blob-sheet.png", "blob-sheet")

class Blob extends Enemy
    textureId: "blob"
    identifier: 201

    constructor: (game, rawData) ->
        super(game, rawData)

        @Bind.Texture("blob-sheet")
        @spriteSheetAnim = @Animations.SpriteSheet(16, 16, 2, step:400)

        @basicFollow = new BasicFollow(@)

    Update: ->
        super()





Torch.Util.Object(MapPieces).Extend(Blob: Blob)



exports.Enemy = Enemy
