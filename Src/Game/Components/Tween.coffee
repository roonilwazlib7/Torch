class Tween extends GameThing
    @MixIn EventDispatcher

    objectToTween: null
    tweenProperties: null
    originalObjectValues: null
    elapsedTime: 0
    timeTweenShouldTake: 0
    easing: null
    repeat: false
    cycle: false

    constructor: (@game, @objectToTween, @tweenProperties, @timeTweenShouldTake, @easing) ->
        @InitEventDispatch()
        @game.Tweens.tweens.push(@)
        @game.Add( @ )

        @originalObjectValues = {}

        for key,value of @tweenProperties
            @originalObjectValues[key] = @objectToTween[key]
    Update: ->
        normalizedTime = @elapsedTime / @timeTweenShouldTake
        easedTime = @Ease(normalizedTime)

        for key,value of @tweenProperties
            @objectToTween[key] = (@tweenProperties[key] * easedTime) + (@originalObjectValues[key] * (1 - easedTime))

        @elapsedTime += @game.Loop.updateDelta
        if @elapsedTime >= @timeTweenShouldTake
            @Emit "Finish", new Torch.Event(@game, {tween: @})

            if @cycle
                @elapsedTime = 0
                tmp = Object.create( @originalObjectValues )
                @originalObjectValues = Object.create( @tweenProperties)
                @tweenProperties = tmp

            else
                @Trash()

    Cycle: ->
        @cycle = true
        return @

    Ease: (normalizedTime) ->
        switch @easing
            when Torch.Easing.Linear
                return normalizedTime

            when Torch.Easing.Square
                return Math.pow(normalizedTime, 2)

            when Torch.Easing.Cube
                return Math.pow(normalizedTime, 3)

            when Torch.Easing.InverseSquare
                return 1 - Math.pow(1 - normalizedTime, 2)

            when Torch.Easing.InverseCube
                return 1 - Math.pow(1 - normalizedTime, 3)

            when Torch.Easing.Smooth
                return normalizedTime * normalizedTime * (3 - 2 * normalizedTime)

            when Torch.Easing.SmoothSquare
                return Math.pow( ( normalizedTime * normalizedTime * ( (3 - 2 * normalizedTime) ) ), 2 )

            when Torch.Easing.SmoothCube
                return Math.pow( ( normalizedTime * normalizedTime * ( (3 - 2 * normalizedTime) ) ), 3 )

            when Torch.Easing.Sine
                return Math.sin(normalizedTime * Math.PI / 2)

            when Torch.Easing.InverseSine
                return 1 - Math.sin( (1 - normalizedTime) * Math.PI / 2 )

class TweenSetup
    constructor: (@game, @object, @timeTweenShouldTake, @easing) ->

    To: (tweenProperties) ->
        return new Tween(@game, @object, tweenProperties, @timeTweenShouldTake, @easing)

    From: (setProperties) ->
        for key,value of setProperties
            @object[key] = value
        return @

class TweenManager
    constructor: (@game) ->
        @tweens = []

    Tween: (object, timeTweenShouldTake, easing = Torch.Easing.Smooth) ->
        return new TweenSetup(@game, object, timeTweenShouldTake, easing)

    All: (callback) ->
        for tween in @game.tweens
            callback(tween)

# # objects or primitives
# game.Tween(sprite.position, 500).To({x: 500, y: 500})
# # or set the properties before tweening
# game.Tween.(sprite.opacity, 500).From(0).To(1)
