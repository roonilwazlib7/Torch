class GamePad
    @MixIn EventDispatcher

    connected: false
    buttons: null
    sticks: null

    constructor: (@game, @index) ->
        @InitEventDispatch()
        @buttons =
            A: new GamePadButton(@, 1)
            B: new GamePadButton(@, 2)
            X: new GamePadButton(@, 3)
            Y: new GamePadButton(@, 4)
            LeftBumper: new GamePadButton(@, 5)
            RightBumper: new GamePadButton(@, 6)
            LeftTrigger: new GamePadButton(@, 7)
            RightTrigger: new GamePadButton(@, 8)
            Back: new GamePadButton(@, 9)
            Start: new GamePadButton(@, 10)
            LeftStick: new GamePadButton(@, 11)
            RightStick: new GamePadButton(@, 12)
            DPadUp: new GamePadButton(@, 13)
            DPadDown: new GamePadButton(@, 14)
            DPadLeft: new GamePadButton(@, 15)
            DPadRight: new GamePadButton(@, 16)


        @buttonMap = ["A", "B", "X", "Y", "LeftBumper", "RightBumper",
                        "LeftTrigger", 'RightTrigger', "Back", "Start",
                        "LeftStick", "RightStick", "DPadUp", "DPadDown",
                        "DPadLeft", "DPadRight"
                     ]

        @sticks =
            LeftStick: new GamePadStick(@)
            RightStick: new GamePadStick(@)

    SetState: (nativeGamePad) ->
        @connected = nativeGamePad.connected
        for nativeButton,index in nativeGamePad.buttons
            button = @buttons[ @buttonMap[index] ]

            if button?
                button.SetState(nativeButton)

        axes = nativeGamePad.axes
        @sticks.LeftStick.SetState( axes[0], axes[1] )
        @sticks.RightStick.SetState( axes[2], axes[3] )


class GamePadManager
    _pads: null
    constructor: (@game) ->
        @_pads = [new GamePad(@game),new GamePad(@game),new GamePad(@game),new GamePad(@game)]

    Pad: (index) ->
        return @_pads[index]

    Update: ->
        nativeGamePads = navigator.getGamepads()

        for pad,index in nativeGamePads

            if pad?
                @_pads[index].SetState(pad)

class GamePadButton
    @MixIn EventDispatcher
    _wasDown: false
    down: false

    constructor: (@gamePad, @buttonCode) ->
        @InitEventDispatch()
        @game = @gamePad.game

    SetState: (nativeGamePadButton) ->
        if @_wasDown and not nativeGamePadButton.pressed
            @Emit "ButtonPressed", new Torch.Event(@game, {button: @})

        @down = nativeGamePadButton.pressed
        @_wasDown = @down

class GamePadStick
    @MixIn EventDispatcher
    horizontalAxis: 0
    verticalAxis: 0
    EPSILON: 0.1

    constructor: (@gamePad) ->

    SetState: (horizontalAxis, verticalAxis) ->
        if Math.abs(horizontalAxis) > @EPSILON
            @horizontalAxis = horizontalAxis
        else
            @horizontalAxis = 0

        if Math.abs(verticalAxis) > @EPSILON
            @verticalAxis = verticalAxis
        else
            @verticalAxis = 0
