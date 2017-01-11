class FunctionUtility
    constructor: (@func) ->

    Defer: (args...) ->
        f = =>
            @func(args...)
        setTimeout(f , 0)

    Once: ->
        oldFunc = @func
        newFunc = (args...) ->
            return if this.called

            oldFunc(args...)
            this.called = true

        return newFunc

    After: (timesBeforeExecuted) ->
        oldFunc = @func
        newFunc = (args...) ->
            this.timesBeforeExecuted += 1
            return if this.calledCount < timesBeforeExecuted

            oldFunc(args...)
            this.called = true

        newFunc.timesBeforeExecuted = 0

        return newFunc

    Before: (timesExecuted) ->
        oldFunc = @func
        newFunc = (args...) ->
            this.timesExecuted += 1
            return if this.calledCount > timesExecuted

            oldFunc(args...)
            this.called = true

        newFunc.timesExecuted = 0

        return newFunc

    Compose: (funcs...) ->
        allFuncs = [@func, funcs...]

        i = 0

        newFunc = ->
            lastReturn = undefined

            while i < allFuncs.length
                lastReturn = allFuncs[i](lastReturn)
                i++

        return newFunc
