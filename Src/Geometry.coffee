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

TorchModule class Polygon
    points: null
    sides: null

    constructor: (@points) ->
        @Resolve()

    Resolve: ->
        sides = []

        len = @points.length

        while len > 0
            len -= 1

            p = @points[ len ]

            if len isnt 0
                sides.push( new Line( p, @points[len - 1] ) )
            else
                sides.push( new Line( p, @points[ @points.length - 1 ] ) )

        @sides = sides

TorchModule class Rectangle
    x: 0
    y: 0
    width: 0
    height: 0
    constructor: (@x, @y, @width, @height) ->

    HalfWidth: -> return @width / 2

    HalfHeight: -> return @height / 2

    GetOffset: (rectangle) ->
        vx = ( @x + @HalfWidth() ) - ( rectangle.x + rectangle.HalfWidth() )
        vy = ( @y + @HalfHeight() ) - ( rectangle.y + rectangle.HalfHeight() )

        halfWidths = @HalfWidth() + rectangle.HalfWidth()
        halfHeights = @HalfHeight() + rectangle.HalfHeight()

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
