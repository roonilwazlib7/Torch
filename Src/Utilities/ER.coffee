# errors
ER = {}

class ER.ER
    message: null
    nativeError: null
    constructor: (fatal) ->
        @Fatal() if fatal
        @nativeError = new Error(@message)

    Fatal: ->
        Torch.FatalError(@message)

    toString: ->
        return @message

class ER.ArgumentError extends ER.ER
    message: null
    constructor: (@argument, @valueProvided, @argumentTypes, fatal = false) ->
        @message = "ArgumentError: value '#{@valueProvided}(#{Util.Type(@valueProvided)})' is not a valid argument for #{@argument}"

        if @argumentTypes?
            @message += "("
            for t,index in @argumentTypes
                @message += "," if index isnt 0
                @message += t
            @message += ")"

        super(fatal)
