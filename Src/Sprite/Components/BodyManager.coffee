class BodyManager
    constructor: (@sprite)->
        @game = @sprite.game
        @velocity = new Vector(0,0)
        @acceleration = new Vector(0,0)
        @omega = 0
        @alpha = 0
        @distance = 0
        @orbit = null

    Update: ->
        dX = @velocity.x * @game.Loop.updateDelta
        dY = @velocity.y * @game.Loop.updateDelta
        @distance += Math.sqrt( (dX * dX) + (dY * dY) )

        @sprite.position.x += dX
        @sprite.position.y += dY

        @velocity.x += @acceleration.x * @game.Loop.updateDelta
        @velocity.y += @acceleration.y * @game.Loop.updateDelta

        @sprite.rotation += @omega * @game.Loop.updateDelta
        @sprite.omega += @alpha * @game.Loop.updateDelta

        if @orbit?
            @orbit.Update()


    Orbit: (spriteToOrbit, speed, length) ->
        @orbit = new Orbit( @sprite, spriteToOrbit, speed, length )
        startPosition = @orbit.GetStartPosition()

        @sprite.game.Tweens.Tween(@sprite.position, 2000, Torch.Easing.Smooth).To({x: startPosition.x, y: startPosition.y})
            .On "Finish", =>
                @orbit.enabled = true

    Debug: (color = "red") ->
        @DEBUG = color

    AngleTo: (otherSprite) ->
        directionVector = @DirectionTo(otherSprite)
        return directionVector.angle

    DistanceTo: (otherSprite) ->
        thisVec = new Vector(@sprite.position.x, @sprite.position.y)
        otherVec = new Vector(otherSprite.position.x, otherSprite.position.y)
        otherVec.SubtractVector(thisVec)
        return otherVec.magnitude

    DirectionTo: (otherSprite) ->
        vec = new Vector( (otherSprite.position.x - @sprite.position.x), (otherSprite.position.y - @sprite.position.y) )
        vec.Normalize()
        return vec

class Orbit
    sprite: null
    game: null
    spriteToOrbit: null
    enabled: false
    orbitSpeed: 0
    orbitAngle: 0
    orbitLength: 0
    constructor: (@sprite, @spriteToOrbit, @orbitSpeed, @orbitLength) ->
        @game = @sprite.game

    Update: ->
        return if not @enabled

        @orbitAngle += @orbitSpeed * @game.Loop.updateDelta

        @sprite.position.x = @orbitLength * Math.cos(@orbitAngle) + ( @spriteToOrbit.position.x + @spriteToOrbit.rectangle.width/2 )
        @sprite.position.y = @orbitLength * Math.sin(@orbitAngle) + ( @spriteToOrbit.position.y + @spriteToOrbit.rectangle.height/2 )

    GetStartPosition: ->
        startX = @orbitLength * Math.cos(0) + ( @spriteToOrbit.position.x + @spriteToOrbit.rectangle.width/2 )
        startY = @orbitLength * Math.sin(0) + ( @spriteToOrbit.position.y + @spriteToOrbit.rectangle.height/2 )

        return new Vector( startX, startY )
