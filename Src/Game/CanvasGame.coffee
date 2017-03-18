class CanvasGame
    torch_type: "Game"
    constructor: (@canvasId, @width, @height, @name, @graphicsType, @pixel = 0) ->
        @InitGame()

    CanvasGame.MixIn(EventDispatcher)

    InitGame: ->
        @InitEventDispatch()
        @InitGraphics()
        @InitComponents()
        @Style()

    InitComponents: ->
        styleString = "background-color:#{Color.Flame.GetHtmlString()}; color:#{Color.Ruby.GetHtmlString()}; font-weight: bold; padding:2px; padding-right:5px;padding-left:5px"
        graphicsString = "WebGL"

        if @graphicsType is Torch.CANVAS then graphicsString = "Canvas"

        console.log("%c Torch v#{Torch::version} |#{graphicsString}| - #{@name}", styleString)

        @Loop = new Loop(@)
        @Assets = new AssetManager(@)
        @Load = new Load(@)
        @Mouse = new Mouse(@)
        @Timer = new Timer(@)
        @Camera = new Camera(@)
        @Layers = new Layers(@)
        @Keys = new Keys(@)
        @Tweens = new TweenManager(@)
        @Particles = new ParticleManager(@)
        @Audio = new Audio(@)
        @Hooks = new HookManager(@)
        @Factory = new GameThingFactory(@)
        @State = new StateMachine(@)
        @GamePads = new GamePadManager(@)
        @Cast = new CastManager(@)

        @deltaTime = 0
        @fps = 0
        @averageFps = 0
        @allFPS = 0
        @ticks = 0
        @zoom = 1
        @uidCounter = 0

        @paused = false

        @boundary = null
        @time = null
        @LastTimeStamp = null

        @things = []
        @DrawStack = []
        @AddStack = []

        @thingMap = {}
        @filter = {}

    InitGraphics: ->
        @canvasNode = document.createElement("CANVAS")
        @canvasNode.width = window.innerWidth
        @canvasNode.height = window.innerHeight

        document.getElementById(@canvasId).appendChild(@canvasNode)

        @canvas = @canvasNode.getContext("2d")
        @Clear("#cc5200")

    PixelScale: ->
        @canvas.mozImageSmoothingEnabled = false
        @canvas.imageSmoothingEnabled = false

        return @

    Start: (configObject) ->
        defaultConfigObject =
            Load: ->
            Update: ->
            Draw: ->
            Init: ->

        Util.Object( defaultConfigObject ).Extend(configObject)

        @load = defaultConfigObject.Load
        @update = defaultConfigObject.Update
        @draw = defaultConfigObject.Draw
        @init = defaultConfigObject.Init

        @load(@)

        @Load.Load()
        @Load.On "LoadFinished", =>
            @init(@)
            @WireUpEvents()
            @Run()

        @canvasNode.width = @width
        @canvasNode.height = @height

        if typeof(@width) is "string"
            @canvasNode.width = document.body.clientWidth

        if typeof(@height) is "string"
            @canvasNode.height = document.body.clientHeight

    Add: (o) ->
        if not o.torch_game_thing
            throw new ER.ArgumentError()

        @uidCounter++
        o.torch_uid = "thing#{@uidCounter}"
        o.torch_add_order = @uidCounter

        @AddStack.push(o)

    GetById: (id) ->
        return @thingMap[id]

    Run: (timestamp) ->
        @Loop.Run(0)

    FatalError: (error) ->
        if @fatal
            return

        @fatal = true

        if typeof error == "string"
            error = new Error(error)

        @Clear("#000")
        stack = error.stack.replace(/\n/g, "<br><br>")
        errorHtml = """
        <code style='color:#C9302Cmargin-left:15%font-size:24px'>#{error}</code>
        <br>
        <code style='color:#C9302Cfont-size:20pxfont-weight:bold'>Stack Trace:</code>
        <br>
        <code style='color:#C9302Cfont-size:20px'>#{stack}</code>
        <br>
        <code style='color:#C9302Cfont-size:18px'>Time: #{@time}</code>
        """
        document.body.innerHTML = errorHtml

        @RunGame = ->
        @Run = ->
        @Emit "FatalError", new Torch.Event @,
            error: error
        throw error

    UpdateThings: ->
        filtered = []
        for thing in @things
            if not thing.trash
                if not thing.paused
                    thing.Update()
                    filtered.push(thing)
            else
                thing.trashed = true

                if thing.Emit?
                    thing.Emit "Trash", new Torch.Event(@)
                    thing.Off()

        @things = filtered
        @things = @things.concat( @AddStack )
        @AddStack = []

    DrawThings: ->
        # we need to clear the entire screen
        @canvas.clearRect(0, 0, @Camera.Viewport.maxWidth, @Camera.Viewport.maxHeight)

        @things.sort (a, b) ->
            if a.drawIndex is b.drawIndex
                return a.torch_add_order - b.torch_add_order

            return a.drawIndex - b.drawIndex

        for sprite in @things
            if not sprite.trash
                sprite.Draw()

    Clear: (color) ->
        if color is undefined
            @FatalError("Cannot clear undefined color")
        if typeof color is "object"
            color = color.hex

        @canvasNode.style.backgroundColor = color
        return @

    SetBoundaries: ( x, y, width, height ) ->
        @boundary = new Rectangle( x, y, width, height )

    getCanvasEvents: ->
        evts = [
            [
                "mousemove", (e) =>
                    @Mouse.SetMousePos(@canvasNode, e)
                    @Emit "MouseMove", new Torch.Event @,
                        nativeEvent: e
            ]
            [
                "mousedown", (e) =>
                    @Mouse.down = true
                    @Emit "MouseDown", new Torch.Event @,
                        nativeEvent: e
            ]
            [
                "mouseup", (e) =>
                    @Mouse.down = false
                    @Emit "MouseUp", new Torch.Event @,
                        nativeEvent: e
            ]
            [
                "touchstart", (e) =>
                    @Mouse.down = true

            ]
            [
                "touchend", (e) =>
                    @Mouse.down = false
            ]
            [
                "click", (e) =>
                    e.preventDefault()
                    e.stopPropagation()
                    @Emit "Click", new Torch.Event @,
                        nativeEvent: e
                    return false
            ]
        ]

        return evts

    getBodyEvents: ->
        bodyEvents =
        [
            [
                "keydown", (e) =>
                    c = e.keyCode
                    key = @Keys.SpecialKey(c)

                    if key is null
                        key = @Keys[String.fromCharCode(e.keyCode).toUpperCase()]

                    key.down = true
                    key.Emit("KeyDown", new Torch.Event(@, {nativeEvent: e}))

            ]
            [
                "keyup", (e) =>
                    c = e.keyCode
                    key = @Keys.SpecialKey(c)

                    if key is null
                        key = @Keys[String.fromCharCode(e.keyCode).toUpperCase()]

                    key.down = false
                    key.Emit("KeyUp", new Torch.Event(@, {nativeEvent: e}))
            ]
        ]
        return bodyEvents

    WireUpEvents: ->
        for eventItem in @getCanvasEvents()
            @canvasNode.addEventListener(eventItem[0], eventItem[1], false)

        for eventItem in @getBodyEvents()
            document.body.addEventListener(eventItem[0], eventItem[1], false)

        # window resize event
        resize = (event) =>
            @Emit "Resize", new Torch.Event @,
                nativeEvent: event

        window.addEventListener( 'resize', resize, false )

        pads = navigator.getGamepads()

    TogglePause: ->
        if not @paused
            @paused = true
        else
            @paused = false
        return @

    Style: ->
        # a few style fixes to get around having a css file

        body = document.body

        body.style.backgroundColor = "black"
        body.style.overflow = "hidden"
        body.style.margin = 0

        canvas = document.getElementsByTagName("CANVAS")[0]
        canvas.style.cursor = "pointer"
