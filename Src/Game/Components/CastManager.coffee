class CastManager
    constructor: (@game) ->

    Ray: (startPoint, endPoint, limit = false) ->
        results = []

        @Emit "SpriteQuery", new Event @,
            query: SpriteQuery.RayCast
            ray: new Line( startPoint, endPoint )
            results: results
            limit: limit

        return results

    Circle: (x, y, radius, limit = false) ->
        results = []

        @Emit "SpriteQuery", new Event @,
            query: SpriteQuery.CircleCast
            circle: new Circle( x, y, radius )
            results: results
            limit: limit

        return results

    Polygon: (points, limit = false) ->
        results = []

        @Emit "SpriteQuery", new Event @,
            query: SpriteQuery.PolygonCast
            polygon: new Polygon( points )
            results: results
            limit: limit

        return results

    Rectangle: (x, y, width, height, limit = false) ->
        results = []

        @Emit "SpriteQuery", new Event @,
            query: SpriteQuery.RectangleCast
            rectangle: new Rectangle( x, y, width, height )
            results: results
            limit: limit

        return results
