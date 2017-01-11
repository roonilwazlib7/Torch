class MathUtility
    constructor: ->
        @RandomPool = RandomPool

    RandomInRange: (min, max) ->
        return Math.random() * (max - min + 1) + min

    Sign: (n) ->
        if n > 0
            return 1
        else if n < 0
            return -1

        return 0

class RandomPool
    choices: null
    constructor: ->
        @choices = []

    AddChoice: (item, probability) ->
        i = probability
        while i > 0
            i--
            @choices.push(item)

    Pick: ->
        @choices = Util.Array( @choices ).Shuffle()
        return @choices[0]
