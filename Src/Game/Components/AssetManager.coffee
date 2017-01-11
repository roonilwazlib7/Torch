class AssetManager
    game: null
    textures: null
    audio: null
    video: null
    files: null
    textureAtlases: null

    constructor: (@game) ->
        @textures = {}
        @audio = {}
        @video = {}
        @textureAtlases = {}
        @files = {}

    GetTexture: (id) ->
        return @textures[id]

    GetAudio: (id) ->
        return @audio[id]

    GetVideo: (id) ->
        return @video[id]

    GetTextureAtlas: (id) ->
        return @textureAtlases[id]

    GetFile: (id) ->
        return @files[id]
