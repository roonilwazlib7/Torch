# The First file in the Torch build chain
GLOBAL_CONTEXT = exports = this

# this is the first file, so any special containers should be declared here
TorchModules = [] # public pieces of torch, i.e Torch.Sprite, Torch.Game
SpriteModules = [] # componenets used by sprites
GameModules = [] # componenets used by games

ModuleFactory = (container) ->

    return ( mod, optionalName ) ->
        name = mod.name

        if optionalName?
            name = optionalName

        container.push( {name: name, mod: mod} )

TorchModule = ModuleFactory( TorchModules )
SpriteModule = ModuleFactory( SpriteModules )
GameModules = ModuleFactory( GameModules )
