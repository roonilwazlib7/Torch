LoadType = Util.Enum("Texture", "Audio", "Video", "File", "TextureAtlas")

class LoadJob
    constructor: (@loadType, @id, @path) ->

class Load
    # TODO:
    # Warn when assets are overwritten

    @MixIn EventDispatcher

    constructor: (@game) ->
        @InitEventDispatch()

        @files = @game.Assets.files
        @textures = @game.Assets.textures
        @audio = @game.Assets.audio
        @video = @game.Assets.video
        @textureAtlases = @game.Assets.textureAtlases

        @loadJobs = []

        @itemsLeftToLoad = 0
        @progress = 0

        @loaded = false

        @loadLog = ""

    Audio: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.Audio, id, path) )

    Texture: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.Texture, id, path) )

    TextureAtlas: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.TextureAtlas, id, path) )

    Video: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.Video, id, path) )

    File: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.File, id, path) )

    Font: (path, name) ->
        # this can be done right off the bat
        style = document.createElement("style")
        manualLoader = document.createElement("p")

        cssFontRule = """
            @font-face{
                font-family: #{name};
                src: url(#{path});
            }
        """
        cssFontRule = document.createTextNode(cssFontRule)
        style.appendChild(cssFontRule)

        manualLoader.innerHTML = "TEST"
        manualLoader.style.fontFamily = name

        document.head.appendChild(style)
        document.body.appendChild(manualLoader)

        #manualLoader.parentNode.removeChild(manualLoader)

    LoadItemFinished: ->
        @itemsLeftToLoad -= 1

        @progress = (@totalLoad - @itemsLeftToLoad) / @totalLoad

        @game.Emit "LoadProgressed", new Event @game,
            progress: @progress

        if @itemsLeftToLoad <= 0
            # load has finished
            document.getElementsByClassName("font-loader")[0]?.remove()
            timeToLoad = (new Date().getTime() - @startTime) / 1000

            @Emit "LoadFinished", new Event @game,
                timeToLoad: timeToLoad

            # successful load
            console.log "%c#{@game.name} loaded in #{timeToLoad}s",
                """background-color:green;
                   color:white;
                   padding:2px;
                   padding-right:5px;
                   padding-left:5px"""

    Load: ->
        @totalLoad = @loadJobs.length
        @itemsLeftToLoad = @totalLoad

        @startTime = new Date().getTime()

        try
            for loadJob in @loadJobs

                switch loadJob.loadType

                    when LoadType.Texture
                        @LoadTexture(loadJob)

                    when LoadType.Video
                        @LoadVideo(loadJob)

                    when LoadType.Audio
                        @LoadAudio(loadJob)

                    when LoadType.File
                        @LoadFile(loadJob)

                    when LoadType.TextureAtlas
                        @LoadTextureAtlas(loadJob)

        catch e
            console.log "%c#{@game.name} could not load!",
                        """background-color:#{Color.Ruby};
                           color:white;
                           padding:2px;
                           padding-right:5px;
                           padding-left:5px"""
            Torch.FatalError(e)

    LoadTexture: (loadJob) ->
        im = new Image()
        im.src = loadJob.path

        @textures[loadJob.id] = im

        im.onload = =>
            @LoadItemFinished()

    LoadTextureAtlas: (loadJob) ->
        loader = new Torch.AjaxLoader(loadJob.path, Torch.AjaxData.Text)
        loader.loadJob = loadJob
        loader.Finish (data, loader) =>
            @LoadItemFinished()
            @textureAtlases[loader.loadJob.id] = JSON.parse(data)
        loader.Load()

    LoadVideo: (loadJob) ->
        video = document.createElement("video")
        video.src = loadJob.path

        @video[loadJob.id] = video

        video.addEventListener "loadeddata", =>
            @LoadItemFinished()

    LoadAudio: (loadJob) ->
        loader = new Torch.AjaxLoader(loadJob.path, Torch.AjaxData.ArrayBuffer)
        loader.loadJob = loadJob
        loader.Finish (data, loader) =>
            @audio[loader.loadJob.id] = {}
            @audio[loader.loadJob.id].encodedAudioData = data
            @game.Audio.DecodeAudioData data, (buffer) =>
                @audio[loader.loadJob.id].audioData = buffer
                @LoadItemFinished()
        loader.Load()

    LoadFile: (loadJob) ->
        loader = new Torch.AjaxLoader(loadJob.path, Torch.AjaxData.Text)
        loader.loadJob = loadJob
        loader.Finish (data, loader) =>
            @LoadItemFinished()
            @files[loader.loadJob.id] = data
        loader.Load()
