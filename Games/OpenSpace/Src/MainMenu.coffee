exports = this

class exports.MainMenu

    constructor: (@game) ->
        textColor = "white"
        fontSize = 18
        @background = new Background(@game)

        @titleText = @game.Factory.Text 0, 300,
            text: "Open Space"
            font: "main-font"
            color: "white"
            fontSize: 48

        @titleText.Center()

        @startButton = @game.Factory.Button 500, 400,
            {
                color: textColor
                text: "Start"
                font: "main-font"
                fontSize: fontSize
            },
            {
                mainBackground: "button-background"
                mouseDownBackground: "button-background-mouse-down"
            }

        @tutorialButton = @game.Factory.Button 500, 500,
            {
                color: textColor
                text: "Tutorial"
                font: "main-font"
                fontSize: fontSize
            },
            {
                mainBackground: "button-background"
                mouseDownBackground: "button-background-mouse-down"
            }

        @creditsButton = @game.Factory.Button 500, 600,
            {
                color: textColor
                text: "Credits"
                font: "main-font"
                fontSize: fontSize
            },
            {
                mainBackground: "button-background"
                mouseDownBackground: "button-background-mouse-down"
            }

        @quitButton = @game.Factory.Button 500, 700,
            {
                color: textColor
                text: "Quit"
                font: "main-font"
                fontSize: fontSize
            },
            {
                mainBackground: "button-background-red"
                mouseDownBackground: "button-background-mouse-down-red"
            }


        @startButton.Center()
        @tutorialButton.Center()
        @creditsButton.Center()
        @quitButton.Center()

        @startButton.On "Click", =>
            @game.State.Switch("startGame")

        @creditsButton.On "Click", =>
            @game.State.Switch("credits")

        @quitButton.On "Click", -> require( 'electron' ).remote.app.quit()

    Trash: ->
        @titleText.Trash()
        @background.Trash()
        @startButton.Trash()
        @tutorialButton.Trash()
        @creditsButton.Trash()
        @quitButton.Trash()

    @Load: (game) ->
        game.Load.Texture("Assets/Art/UI/purple_button00.png", "button-background")
        game.Load.Texture("Assets/Art/UI/purple_button01.png", "button-background-mouse-down")

        game.Load.Texture("Assets/Art/UI/red_button00.png", "button-background-red")
        game.Load.Texture("Assets/Art/UI/red_button01.png", "button-background-mouse-down-red")
