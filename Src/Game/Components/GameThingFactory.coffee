class GameThingFactory
    game: null
    constructor: (@game) ->

    Sprite: (x, y, texture) ->
        sprite = new Sprite( @game, x, y )
        sprite.Bind.Texture(texture) if texture?

        return sprite

    Group: (x, y) ->
        group = new SpriteGroup(@game, x, y )

        return group

    Text: (x, y, config = {}) ->
        text = new Text(@game, x, y, config)

        return text

    Thing: (update, draw) ->
        thing = new GameThing()

        thing.Update = update if update?
        thing.Draw = draw if draw?

        @game.Add( thing )

        return thing

    Button: (x, y, textConfig, backgroundConfig) ->
        text = @Text x, y,
            text: textConfig.text or "button"
            color: textConfig.color or "white"
            font: textConfig.font or "monospace"
            fontSize: textConfig.fontSize or 12

        button = @Sprite(x, y, backgroundConfig.mainBackground)

        text.Grid.Center().CenterVertical()
        button.Grid.Append( text )

        button.On "Trash", ->
            text.Trash()

        button.On "MouseDown", ->
            button.Bind.Texture( backgroundConfig.mouseDownBackground or backgroundConfig.mainBackground )

        button.On "MouseUp", ->
            button.Bind.Texture backgroundConfig.mainBackground

        return button
