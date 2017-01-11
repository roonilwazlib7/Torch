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
    #__torch__: Torch.Types.Vector
    x: null
    y: null
    angle: null
    magnitude: null

    constructor: (@x, @y) ->
        @ResolveVectorProperties()

    ResolveVectorProperties: ->
        @magnitude = Math.sqrt( @x * @x + @y * @y )
        @angle = Math.atan2(@y, @x)

    Resolve: ->
        @ResolveVectorProperties()

    Clone: ->
        return new Vector(@x, @y)

    Set: (x,y) ->
        @x = x
        @y = y
        @ResolveVectorProperties()

    AddScalar: (n) ->
        @x += n
        @y += n
        @ResolveVectorProperties()

    MultiplyScalar: (n) ->
        @x *= n
        @y *= n
        @ResolveVectorProperties()

    DivideScalar: (n) ->
        @x /= n
        @y /= n
        @ResolveVectorProperties()

    SubtractVector: (v) ->
        @x -= v.x
        @y -= v.y
        @ResolveVectorProperties()

    AddVector: (v) ->
        @x += v.x
        @y += v.y
        @ResolveVectorProperties()

    Normalize: ->
        @DivideScalar(@magnitude)

    DotProduct: (v) ->
        return @x * v.x + @y * v.y

    Reverse: ->
        @MultiplyScalar( -1 )

    IsPerpendicular: (v) ->
        return @DotProduct(v) is 0

    IsSameDirection: (v) ->
        return @DotProduct(v) > 0

TorchModule class Point
    constructor: (@x, @y, @z = 0) ->

    Apply: (point) ->
        @x += point.x
        @y += point.y

    Subtract: (p) ->
        return new Point( p.x - @x, p.y - @y )

    Clone: ->
        return new Point(@x, @y)

    @GetCenterPoint: (points) ->
        maxX = 0
        maxY = 0

        minY = Infinity
        minX = Infinity

        for point in points
            if point.x > maxX then maxX = point.x
            if point.y > maxY then maxY = point.y

            if point.x < minX then minX = point.x
            if point.y < minY then minY = point.y

        return new Point( (maxX - minX) * 0.5, ( maxY - minY) * 0.5)
