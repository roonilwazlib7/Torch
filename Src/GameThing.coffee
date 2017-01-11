# this is the base of anything in the game

TorchModule class GameThing
    @MixIn Trashable

    torch_game_thing: true
    torch_uid: null
    torch_add_order: null
    game: null
    drawIndex: 0

    Update: ->

    Draw: ->

    Id: (id) ->
        @game.thingMap[ id ] = @
