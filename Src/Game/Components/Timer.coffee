class Timer
    constructor: (@game)->

    SetFutureEvent: (timeToOccur, handle) ->
        ev = new FutureEvent(timeToOccur, handle, @game)
        @game.Add( ev )

        return ev

    SetScheduledEvent: (interval, handle) ->
        ev = new ScheduledEvent(interval, handle, @game)
        @game.Add( ev )

        return ev

class FutureEvent extends GameThing

    constructor: (@timeToOccur, @handle, @game) ->
        @time = 0
    Update: ->
        @time += @game.Loop.updateDelta
        if @time >= @timeToOccur
            if @handle isnt null and @handle isnt undefined
                @handle()
                @handle = null

class ScheduledEvent extends GameThing

    constructor: (@interval, @handle, @game) ->
        @elapsedTime = 0

    Update: ->
        @elapsedTime += @game.Loop.updateDelta

        if @elapsedTime >= @interval
            @handle() if @handle?
            @elapsedTime = 0
