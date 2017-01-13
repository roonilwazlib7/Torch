# Stuff used throughout Torch
GLOBAL_CONTEXT = exports = this
# this is the first file, so any special containers should be declared here
TorchModules = [] # public pieces of torch, i.e Torch.Sprite, Torch.Game
TorchModule = (mod, optionalName) ->
    name = mod.name
    if optionalName?
        name = optionalName

    TorchModules.push({name: name, mod: mod})

class Utilities
    constructor: ->
        @Math = new MathUtility()

    String: (str) ->
        return new StringUtility(str)

    Array: (array) ->
        return new ArrayUtility(array)

    Function: (func) ->
        return new FunctionUtility(func)

    Object: (obj) ->
        return new ObjectUtility(obj)

    Type: (obj) ->
        if obj?
            return obj.torch_type if obj.torch_type?
            classToType = {}

            types = [
                "Boolean"
                "Number"
                "String"
                "Function"
                "Array"
                "Date"
                "RegExp"
                "Undefined"
                "Null"
            ]

            for name in types
                classToType[ "[object #{name}]" ] = name.toLowerCase()

            strType = Object::toString.call(obj)
            return classToType[strType] or "object"

        else
            return null


    Enum: (parts...) ->
        obj = {
            nameMap: {}
        }
        obj.GetStringValue = (en) ->
            return @nameMap[en]

        for part,i in parts
            obj[part] = i+1
            obj.nameMap[i+1] = part

        return obj


# define a local (to Torch) instance for use by the rest
# of the library
Util = new Utilities()
