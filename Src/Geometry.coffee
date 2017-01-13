TorchModule class Rectangle
    constructor: (@x, @y, @width, @height) ->
        @z = 0

    GetOffset: (rectangle) ->
        vx = ( @x + ( @width / 2 ) ) - ( rectangle.x + ( rectangle.width / 2 ) )
        vy = ( @y + (@height / 2 ) ) - ( rectangle.y + ( rectangle.height / 2 ) )
        halfWidths = (@width / 2) + (rectangle.width / 2)
        halfHeights = (@height / 2) + (rectangle.height / 2)
        sharedXPlane = (@x + @width) - (rectangle.x + rectangle.width)
        sharedYPlane = (@y + @height) - (rectangle.y + rectangle.height)

        offset =
            x: halfWidths - Math.abs(vx)
            y: halfHeights - Math.abs(vy)
            vx: vx
            vy: vy
            halfWidths: halfWidths
            halfHeights: halfHeights
            sharedXPlane: sharedXPlane
            sharedYPlane: sharedYPlane

        return offset


    Intersects: (rectangle) ->
        a = @
        b = rectangle
        if a.x < (b.x + b.width) && (a.x + a.width) > b.x && a.y < (b.y + b.height) && (a.y + a.height) > b.y
            return a.GetOffset(b)
        else
            return false

    ShiftFrom: (rectangle, transX, transY) ->
        x = null
        y = null

        if transX is undefined then x = rectangle.x
        else x = rectangle.x + transX

        if transY is undefined then y = rectangle.y
        else y = rectangle.y + transY

        @x = x
        @y = y

TorchModule class Vector
    x: 0
    y: 0
    angle: 0
    magnitude: 0

    constructor: (@x, @y) ->
        @Resolve()

    Resolve: ->
        @magnitude = Math.sqrt( @x * @x + @y * @y )
        @angle = Math.atan2(@y, @x)

        return @ # allow chaining

    Clone: ->
        return new Vector(@x, @y)

    X: (x) ->
        xType = Util.Type(x)
        throw new Error("argument 'x' must be a number, got #{xType}") if xType isnt "number"

        @x = x
        @Resolve()

    Y: (y) ->
        yType = Util.Type(y)
        throw new Error("argument 'y' must be a number, got #{yType}") if yType isnt "number"

        @y = y
        @Resolve()

    Set: (x,y) ->
        @x = x
        @y = y
        @Resolve()

    AddScalar: (n) ->
        @x += n
        @y += n
        @Resolve()

    MultiplyScalar: (n) ->
        @x *= n
        @y *= n
        @Resolve()

    DivideScalar: (n) ->
        @x /= n
        @y /= n
        @Resolve()

    SubtractVector: (v) ->
        @x -= v.x
        @y -= v.y
        @Resolve()

    AddVector: (v) ->
        @x += v.x
        @y += v.y
        @Resolve()

    Reverse: ->
        @MultiplyScalar( -1 )
        @Resolve()

    Normalize: (preResolve = false)->
        @Resolve() if preResolve

        @DivideScalar(@magnitude)

        return @

    DotProduct: (v) ->
        return @x * v.x + @y * v.y

    IsPerpendicular: (v) ->
        return @DotProduct(v) is 0

    IsSameDirection: (v) ->
        return @DotProduct(v) > 0
