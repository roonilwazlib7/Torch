class BindManager
    constructor: (@sprite) ->

    Texture: (textureId, optionalParameters) ->
        tex = null

        # check if the first argument is a string or object
        textureIdType = Util.Type(textureId)

        if textureIdType is "string"
            # fetch a pre-loaded texture
            rawImage = @sprite.game.Assets.GetTexture(textureId)
            tex = new Texture( rawImage )

        else if textureIdType is "object"
            # bind texture directly
            tex = new Texture( textureId )

        else throw new ER.ArgumentError("textureId", textureId, ["string", "object"])

        @sprite.Size.Set(tex.width, tex.height)
        @sprite.texture = tex

    Video: (videoId) ->
        video = null

        # check for a string or object
        videoIdType = Util.Type(videoId)

        if videoIdType is "string"
            # fetch a pre-loaded video
            rawVideo = @sprite.game.Assets.GetVideo(videoId)
            video = new Video( rawVideo )

        else if videoIdType is "object"
            video = new Video( rawVideo )

        else throw new ER.ArgumentError( "videoId", videoId, ["string", "object"] )

        @sprite.video = video
        @sprite.Size.Set(video.width, video.height)

    Atlas: (textureId, textureAtlasId, textureName) ->
        # set it to the texture the atlas is mapped against
        @Texture(textureId)

        #grab the atlas
        textureAtlas = @sprite.game.Assets.GetTextureAtlas(textureAtlasId)

        atlasItem = textureAtlas.textures[textureName]

        # set the clip properties
        @sprite.texture.drawParams.clipX = atlasItem.x
        @sprite.texture.drawParams.clipY = atlasItem.y

        @sprite.texture.drawParams.clipWidth = atlasItem.width
        @sprite.texture.drawParams.clipHeight = atlasItem.height

        # set the sprite width
        @sprite.Size.Set(atlasItem.width, atlasItem.height)
