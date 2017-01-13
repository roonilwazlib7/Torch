# The First file in the Torch build chain
GLOBAL_CONTEXT = exports = this

# this is the first file, so any special containers should be declared here
TorchModules = [] # public pieces of torch, i.e Torch.Sprite, Torch.Game
TorchModule = (mod, optionalName) ->
    name = mod.name
    if optionalName?
        name = optionalName

    TorchModules.push({name: name, mod: mod})
