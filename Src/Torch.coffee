###
    A few notes to keep in mind:

    - CoffeeScript wraps each file into it's own scope when it is compiled into
      javascript. When Torch is built, it puts all the coffeescript into one file
      (torch-latest.coffee) thus throwing all of Torch into the same scope. The only
      piece that is exposed is an instance of Torch called 'Torch'

    - There are a few custom objects that are defined in the torch scope a little odly:
       - Util - An instance of Utilities, used internally by Torch, exported as Torch.Util
###
class Event
    constructor: (@game, @data) ->
        if @game isnt null
            @time = @game.time
        for key,value of @data
            @[key] = value

class Torch

    CANVAS: 1
    WEBGL: 2
    PIXEL: 3

    DUMP_ERRORS: false

    @GamePads: Util.Enum("Pad1", "Pad2", "Pad3", "Pad4")
    @AjaxData: Util.Enum("DOMString", "ArrayBuffer", "Blob", "Document", "Json", "Text")
    @Types: Util.Enum("String", "Number", "Object", "Array", "Function", "Sprite", "Game", "Null")
    @Easing: Util.Enum("Linear", "Square", "Cube", "InverseSquare", "InverseCube",
                        "Smooth", "SmoothSquare", "SmoothCube", "Sine", "InverseSine")

    @AjaxLoader: AjaxLoader
    @Event: Event
    @Util: new Utilities() # a static reference for use within torch

    constructor: ->
        @GamePads = Torch.GamePads
        @AjaxData = Torch.AjaxData
        @Types = Torch.Types
        @Easing = Torch.Easing

        @Util = Util

        for mod in TorchModules
            @[mod.name] = mod.mod

    @FatalError: (error) ->
        return if @fatal
        @fatal = true

        if Util.Type(error) is "string"
            error = new Error(error)
        else if not error.stack?
            error = error.nativeError

        document.body.backgroundColor = "black"

        if @DUMP_ERRORS
            if require isnt undefined
                require("fs").writeFileSync("torch-error.log", error.stack)

        stack = error.stack.replace(/\n/g, "<br><br>")

        errorHtml = """
        <code style='color:#C9302C;margin-left:15%;font-size:24px'>#{error}</code>
        <br>
        <code style='color:#C9302C;font-size:20px;font-weight:bold'>Stack Trace:</code><br>
        <code style='color:#C9302C;font-size:20px'>#{stack}</code><br>
        """
        document.body.innerHTML = errorHtml

    StrictErrors: ->
        @STRICT_ERRORS = true

    DumpErrors: ->
        @DUMP_ERRORS = true

exports.Torch = new Torch()
