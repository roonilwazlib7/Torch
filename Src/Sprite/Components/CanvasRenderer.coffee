class CanvasRenderer
    constructor: (@sprite) ->
        @game = @sprite.game
        @previousPosition = new Vector(@sprite.position.x, @sprite.position.y)
    Draw: ->
        drawRec = new Rectangle(@sprite.position.x, @sprite.position.y, @sprite.rectangle.width, @sprite.rectangle.height)

        drawRec.x = ( @sprite.position.x - @previousPosition.x ) * @game.Loop.lagOffset + @previousPosition.x
        drawRec.y = ( @sprite.position.y - @previousPosition.y ) * @game.Loop.lagOffset + @previousPosition.y
        @previousPosition = new Vector(@sprite.position.x, @sprite.position.y)

        cameraTransform = new Vector(0,0)

        if not @sprite.fixed
            drawRec.x += @game.Camera.position.x + @game.Hooks.positionTransform.x
            drawRec.y += @game.Camera.position.y + @game.Hooks.positionTransform.y

        # we need to run the above logic even if we aren't "drawing" the sprite
        return if not @sprite.draw
        switch @sprite.torch_render_type
            when "Image"
                @RenderImageSprite(drawRec)
            when "Line"
                @RenderLineSprite(drawRec)
            when "Box"
                @RenderBoxSprite(drawRec)
            when "Circle"
                @RenderCircleSprite(drawRec)
            when "Polygon"
                @RenderPolygonSprite(drawRec)

    RenderImageSprite: (drawRec) ->
        if @sprite.texture? or @sprite.video?
            frame = @sprite.texture or @sprite.video
            params = frame.drawParams

            # Set the canvas state
            canvas = @game.canvas
            canvas.save()
            @SetCanvasStates(canvas, drawRec.x + drawRec.width / 2, drawRec.y + drawRec.height / 2)

            if @sprite.Effects.tint.color isnt null
                canvas.fillStyle = @sprite.Effects.tint.color
                canvas.globalAlpha = @sprite.Effects.tint.opacity
                canvas.globalCompositeOperation = "destination-atop"
                canvas.fillRect(-drawRec.width/2, -drawRec.height/2, drawRec.width, drawRec.height)
                canvas.globalAlpha = @sprite.opacity

            # draw the image
            canvas.drawImage(@sprite.video?.video or @sprite.texture.image, params.clipX, params.clipY,
            params.clipWidth, params.clipHeight,-drawRec.width/2 + @sprite.rotationOffset.x,
            -drawRec.height/2 + @sprite.rotationOffset.y,
            drawRec.width, drawRec.height)

            if @sprite.Body.DEBUG
                canvas.fillStyle = @sprite.Body.DEBUG
                canvas.globalAlpha = 0.5
                canvas.fillRect(-drawRec.width/2, -drawRec.height/2, drawRec.width, drawRec.height)

            canvas.restore()

    RenderLineSprite: (drawRec) ->
        # lines are special
        @game.canvas.save()

        @game.canvas.globalAlpha = @sprite.opacity
        @game.canvas.strokeStyle = @sprite.color
        @game.canvas.lineWidth = @sprite.lineWidth

        if @sprite.DrawTexture?.image?
            @game.canvas.strokeStyle = @game.canvas.createPattern( @sprite.DrawTexture.image, "repeat" )

        @game.canvas.beginPath()
        @game.canvas.moveTo(drawRec.x, drawRec.y)
        @game.canvas.lineTo( @sprite.endPosition.x + @game.Camera.position.x, @sprite.endPosition.y + @game.Camera.position.y )
        @game.canvas.stroke()

        @game.canvas.restore()

    RenderCircleSprite: (drawRec) ->
        @game.canvas.save()
        @game.canvas.translate(drawRec.x + @sprite.radius / 2, drawRec.y + @sprite.radius / 2)

        @game.canvas.globalAlpha = @sprite.opacity

        @game.canvas.strokeStyle = @sprite.strokeColor
        @game.canvas.fillStyle = @sprite.fillColor

        @game.canvas.beginPath()

        @game.canvas.arc(0, 0, @sprite.radius, @sprite.startAngle, @sprite.endAngle, @sprite.drawDirection is "counterclockwise")

        @game.canvas.fill()
        @game.canvas.stroke()

        @game.canvas.restore()

    RenderBoxSprite: (drawRec) ->
        @game.canvas.save()

        @SetCanvasStates(@game.canvas, drawRec.x + @sprite.width / 2, drawRec.y + @sprite.height / 2)

        @game.canvas.beginPath()

        @game.canvas.rect(-@sprite.width/2, -@sprite.height/2, @sprite.width, @sprite.height)

        @game.canvas.fill()
        @game.canvas.stroke()

        @game.canvas.restore()

    RenderPolygonSprite: (drawRec) ->
        @game.canvas.save()

        centerPoint = Point.GetCenterPoint(@sprite.points)

        @SetCanvasStates(@game.canvas, drawRec.x + centerPoint.x / 2, drawRec.y + centerPoint.y / 2)

        @game.canvas.beginPath()
        @game.canvas.moveTo(0, 0)

        for point in @sprite.points
            @game.canvas.lineTo(point.x, point.y)

        @game.canvas.closePath()
        @game.canvas.stroke()
        @game.canvas.fill()

        @game.canvas.restore()

    SetCanvasStates: (canvas, transFormX, transFormY)->
        canvas.globalAlpha = @sprite.opacity        if @sprite.opacity?
        canvas.strokeStyle = @sprite.strokeColor    if @sprite.strokeColor?
        canvas.fillStyle = @sprite.fillColor        if @sprite.fillColor?

        canvas.translate(transFormX, transFormY)
        canvas.rotate(@sprite.rotation)
