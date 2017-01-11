# errors
ER = {}

class ER.ER
    message: null
    nativeError: null
    constructor: (fatal) ->
        @Fatal() if fatal
        @nativeError = new Error(@message)

    Fatal: ->
        Torch.FatalError(@message)

    toString: ->
        return @message

class ER.ArgumentError extends ER.ER
    message: null
    constructor: (@argument, @valueProvided, @argumentTypes, fatal = false) ->
        @message = "ArgumentError: value '#{@valueProvided}(#{Util.Type(@valueProvided)})' is not a valid argument for #{@argument}"

        if @argumentTypes?
            @message += "("
            for t,index in @argumentTypes
                @message += "," if index isnt 0
                @message += t
            @message += ")"

        super(fatal)

class ArrayUtility
    constructor: (@array) ->

    Array: ->
        return @array

    All: (applier) ->
        for item in @array
            applier(item)

    Find: (selector) ->
        for item in @array
            return item if selector(item)

    Filter: (selector) ->
        selectedItems = []
        for item in @array
            selectedItems.push(item) if selector(item)
        return selectedItems

    Reject: (selector) ->
        selectedItems = []
        for item in @array
            selectedItems.push(item) if not selector(item)
        return selectedItems

    Where: (properties) ->
        items = @Filter (item) ->
            for key,value of properties
                if item[key] isnt value
                    return false
            return true

        return items

    Every: (selector) ->
        for item in @array
            return false if not selector(item)

        return true

    Some: (selector) ->
        for item in @array
            return true if selector(item)

        return false

    Contains: (item, startIndex = 0) ->
        index = @array.indexOf(item)
        return ( index isnt -1 and index >= startIndex )

    Pluck: (propertyName) ->
        properties = []

        for item in @array
            properties.push( item[propertyName] )

        return properties

    Max: (selector) ->
        currentMax = 0
        if not selector?
            selector = (item) -> return item

        for item in @array
            compareValue = selector(item)
            if compareValue > currentMax
                currentMax = item

        return currentMax

    Min: (selector) ->
        currentMin = 0
        if not selector?
            selector = (item) -> return item

        for item in @array
            compareValue = selector(item)
            if compareValue < currentMin
                currentMin = compareValue

        return currentMin

    SortBy: (sorter) ->

    GroupBy: (grouper) ->
        if not grouper?
            grouper = (item) -> return item.toString().length

        groups = {}

        for item in @array
            group = grouper(item)

            if not groups[group]?
                groups[group] = [ item ]
            else
                groups[group].push(item)

        return groups

    CountBy: (grouper) ->
        groups = @GroupBy(grouper)

        for key,value of groups
            groups[key] = value.length

        return groups

    Shuffle: ->
        currentIndex = @array.length
        temporaryValue = currentIndex
        randomIndex = currentIndex

        #While there remain elements to shuffle...
        while 0 isnt currentIndex

            #Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex)
            currentIndex -= 1

            #And swap it with the current element.
            temporaryValue = @array[currentIndex]
            @array[currentIndex] = @array[randomIndex]
            @array[randomIndex] = temporaryValue

        return @array

    Sample: (n = 1) ->
        sample = []
        while n > 0
            n--
            # needs work

    Partition: (checker) ->
        return [ @Filter(checker), @Reject(checker) ]

    First: (n = 1) ->
        return @array[0] if n is 1

        items = []
        while n <= @array.length
            items.push( @array[ n - 1 ] )
            n++

        return items

    Last: (n = 1) ->
        return @array[ @array.length - 1 ] if n is 1

        items = []
        while n <= @array.length
            items.push( @array[ @array.length - (n - 1) ] )
            n++

        return items

    Flatten: ->
        # reduce 'list of lists' down to one list

    Without: (values...) ->
        filteredItems = []

        for item in @array
            filteredItems.push( item ) if values.indexOf(item) is -1

        return filteredItems

    Union: (arrays...) ->
        ars = [@array, arrays...]
        combinedArray = []

        for ar in ars
            for item in ar
                combinedArray.push(item) if combinedArray.indexOf(item) is -1

        return combinedArray

    Intersection: (arrays...) ->
        ars = [@array, arrays...]
        combinedArray = []
        index = {}

        for ar in ars
            for item in ar
                if not index[item]?
                    index[item] = 1
                else
                    index[item] += 1

        for key,value of index
            if value >= arrays.length
                combinedArray.push(key)

        return combinedArray

    Uniq: ->
        # reduce array to unique values

    Zip: (arrays...) ->
        combinedArray = []

        for item,index in @array
            piece = [ item ]

            for ar in arrays
                piece.push( ar[index] )

            combinedArray.push(piece)

        return combinedArray

    UnZip: (arrays...) ->
        # opposite of Zip...

class StringUtility
    constructor: (@str) ->

    String: ->
        return @str

    Chunk: (chunkLength) ->
        @str = @str.match(new RegExp('.{1,' + chunkLength + '}', 'g'));
        return @str

    Capitalize: ->
        @str[0] = @str[0].toUpperCase()
        return @str

class FunctionUtility
    constructor: (@func) ->

    Defer: (args...) ->
        f = =>
            @func(args...)
        setTimeout(f , 0)

    Once: ->
        oldFunc = @func
        newFunc = (args...) ->
            return if this.called

            oldFunc(args...)
            this.called = true

        return newFunc

    After: (timesBeforeExecuted) ->
        oldFunc = @func
        newFunc = (args...) ->
            this.timesBeforeExecuted += 1
            return if this.calledCount < timesBeforeExecuted

            oldFunc(args...)
            this.called = true

        newFunc.timesBeforeExecuted = 0

        return newFunc

    Before: (timesExecuted) ->
        oldFunc = @func
        newFunc = (args...) ->
            this.timesExecuted += 1
            return if this.calledCount > timesExecuted

            oldFunc(args...)
            this.called = true

        newFunc.timesExecuted = 0

        return newFunc

    Compose: (funcs...) ->
        allFuncs = [@func, funcs...]

        i = 0

        newFunc = ->
            lastReturn = undefined

            while i < allFuncs.length
                lastReturn = allFuncs[i](lastReturn)
                i++

        return newFunc

class ObjectUtility
    constructor: (@obj) ->

    Keys: ->
        keys = []

        for key,value of @obj
            keys.push(key)

        return keys

    Values: ->
        values = []

        for key,value of @obj
            values.push(value)

        return values

    All: (applier) ->
        for key,value of @obj
            @obj[key] = applier(key,value)

        return @obj

    Invert: ->
        newObj = {}
        for key,value of @obj
            newObj[value] = key

        return newObj

    Functions: ->
        functionList = []

        for key,value of @obj
            functionList.push( value.name ) if typeof(value) is "function"

        return functionList

    Extend: (objects...)->
        for obj in objects

            for key,value of obj
                @obj[key] = value

        return @obj

    Pick: (pickKeys...) ->
        newObj = {}

        if typeof(pickKeys) is "function"
            for key,value of @obj
                newObj[key] = value if pickKeys(key, value, @obj)

        else
            for key in pickKeys
                newObj[key] = @obj[key]

        return newObj

    Omit: (omitKeys...) ->
        newObj = {}

        if typeof(omitKeys) is "function"
            for key,value of @obj
                newObj[key] = value if not omitKeys(key, value, @obj)

        else
            for key,value of @obj
                newObj[key] = @obj[key] if omitKeys.indexOf(key) is -1

        return newObj

    Clone: ->
        #... a good clone

    Has: (key) ->
        return false if not @obj[key]?
        return true

    Matches: (otherObj) ->
        for key,value of otherObj
            return false if @obj[key] isnt value

        return true

    Empty: ->
        return @Keys().length is 0

class MathUtility
    constructor: ->
        @RandomPool = RandomPool

    RandomInRange: (min, max) ->
        return Math.random() * (max - min + 1) + min

    Sign: (n) ->
        if n > 0
            return 1
        else if n < 0
            return -1

        return 0

class RandomPool
    choices: null
    constructor: ->
        @choices = []

    AddChoice: (item, probability) ->
        i = probability
        while i > 0
            i--
            @choices.push(item)

    Pick: ->
        @choices = Util.Array( @choices ).Shuffle()
        return @choices[0]

# Stuff used throughout Torch

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

# TODO
# use EventDispatcher instead of hard-coded event listeners
class AjaxLoader
    onFinish: ->
    onError: ->

    constructor: (url, responseType = window.Torch.AjaxData.Text) ->
        @url = url
        @responseType = @GetResponseTypeString(responseType)

    GetResponseTypeString: (responseType) ->
        switch responseType
            when window.Torch.AjaxData.DOMString then      return ""
            when window.Torch.AjaxData.ArrayBuffer then    return "arraybuffer"
            when window.Torch.AjaxData.Blob then           return "blob"
            when window.Torch.AjaxData.Document then       return "document"
            when window.Torch.AjaxData.Json then           return "json"
            when window.Torch.AjaxData.Text then           return "text"

    Error: (func) -> @onError = func

    Finish: (func) -> @onFinish = func

    Load: ->
        request = new XMLHttpRequest()
        request.open('GET', @url, true)
        request.responseType = @responseType

        request.onload = =>
            @onFinish(request.response, @)

        request.send()

# Catch all errors
window?.onerror = (args...) ->
    return if not window.Torch.STRICT_ERRORS

    document.body.style.backgroundColor = "black"

    errorObj = args[4]

    if errorObj isnt undefined
        Torch.FatalError(errorObj)
    else
        Torch.FatalError("An error has occured")

# Modify some core js prototypes
Function::MixIn = Function::is = (otherFunction) ->
    proto = this.prototype
    items = Object.create(otherFunction.prototype)

    for key,value of items
        proto[key] = value

    return this #allow chaining

# ECMAscript 5 property get/set
Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

class EventDispatcher
    @dispatchers: []

    InitEventDispatch: ->
        @events = {}
        EventDispatcher.dispatchers.push(@)

    On: (eventName, eventHandle) ->
        if not @events[eventName]
            eventNest = []
            eventNest.triggers = 0

            @events[eventName] = eventNest

        @events[eventName].push(eventHandle)

        return @

    Emit: (eventName, eventArgs) ->
        if @events[eventName] isnt undefined
            for ev in @events[eventName]
                @events[eventName].triggers++
                ev(eventArgs)
        return @

    Off: (eventName = "") ->
        if eventName isnt ""
            @events[eventName] = undefined
        else
            for key,val of @events
                @events[key] = undefined
        return @

class Trashable
    trash: false
    trashed: false
    Trash: ->
        @trash = true

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

TorchModule class DebugConsole
    enabled: false
    console: null
    consoleInput: null
    consoleOutput: null
    commands: null
    variables: null
    constructor: (@game) ->
        html = """
                <div id = "torch-console" style = "position: absolute;z-index: 100;top:0;border: 1px solid orange;background-color:black">
                    <p style = "color:white;margin-left:1%;font-family:monospace">Torch Dev Console. Type /HELP for usage</p>
                    <input type="text" id = "torch-console-input" placeholder="Torch Dev Console, type /HELP for usage"/ style = "outline: none;border: none;font-family: monospace;color: white;background-color: black;font-size: 16px;padding: 3%;width: 100%;" />
                    <div id = "torch-console-output" style = "overflow:auto;outline: none;border: none;font-family: monospace;color: white;background-color: black;font-size: 14px;padding: 1%;width: 98%;height:250px"></div>
                </div>
        """
        div = document.createElement("div")

        div.innerHTML = html
        div.style.display = "none"

        document.body.appendChild(div)

        @console = div
        @consoleInput = document.getElementById("torch-console-input")
        @consoleOutput = document.getElementById("torch-console-output")
        @commands = {}
        @variables = {}

        @LoadDefaultCommands()

        document.addEventListener "keypress", (e) =>
            if e.keyCode is 47
                @Toggle(true)

            else if e.keyCode is 13
                @ParseCommand()

        document.addEventListener "keydown", (e) =>
            if e.keyCode is 27
                @Toggle(false)

    Toggle: (tog = true) ->

        if tog
            @console.style.display = "block"
            @consoleInput.focus()
            @enabled = true
            Util.Array(@game.things).All (thing) -> if thing.Pause then thing.Pause()
        else
            @console.style.display = "none"
            @consoleInput.value = ""
            @enabled = false
            Util.Array(@game.things).All (thing) -> if thing.Pause then thing.Pause(false)

    Output: (content, color = "white") ->
        content = content.replace(/\n/g, "<br>")
        @consoleOutput.innerHTML += "<p style='color:orange'>TorchDev$</p><p style='color:#{color}'>#{content}</p>"

    ParseCommand: ->
        return if not @enabled

        commandText = @consoleInput.value

        # put in environment vars
        commandText = commandText.replace /\$(.*?)\$/g, (text) =>
             clippedText = text.substring(1,text.length-1)
             return @variables[clippedText]

        command = commandText.split(" ")[0].split("/")[1]
        args = []

        for option,index in commandText.split(" ")
            args.push(option) if index isnt 0

        @ExecuteCommand(command, args)

    ExecuteCommand: (command, args) ->
        if not @commands[command]
            @Output("Command '#{command}' does not exist.", "red")
            return
        else
            @commands[command]( @, args... )

    AddCommand: (name, callback) ->
        @commands[name] = callback

    LoadDefaultCommands: ->
        @AddCommand "HELP", (tConsole) =>
            tConsole.Output """
            type '/HELP' for help
            type '/FPS' for frame rate
            type '/TIME' for game time
            type '/E [statement]' to execute a JavaScript statement
            type '/RUN [path] to load and execute a JavaScript file'
            """
        @AddCommand "CLEAR", (tConsole) =>
            @consoleOutput.innerHTML = ""
        @AddCommand "FPS", (tConsole) =>
            tConsole.Output """
            Current FPS: #{@game.fps}
            Average FPS: #{0}
            """
        @AddCommand "TIME", (tConsole) =>
            tConsole.Output """
            Total Game Time: #{@game.time}
            Delta Time: #{@game.deltaTime}
            """
        @AddCommand "RUN", (tConsole, filePath) =>
            loader = new Torch.AjaxLoader(filePath, Torch.AjaxData.Text)
            loader.Finish (data) =>
                try
                    eval(data)
                    tConsole.Output("File Executed", "green")
                catch error
                    tConsole.Output("File: '#{statement}' caused an error. #{error}", "red")

            loader.Load()

        @AddCommand "SET", (tConsole, name, value) =>
            if isNaN(value)
                @variables[name] = value
            else
                @variables[name] = parseFloat(value)

            @Output("Set #{name} to #{value}", "green")

        @AddCommand "E", (tConsole, statement) =>
            try
                eval(statement)
                tConsole.Output("Statment Executed", "green")
            catch error
                tConsole.Output("Statement: '#{statement}' caused an error. #{error}", "red")

temp = null
if this[ "PF" ] then temp = this[ "PF" ]
`
!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.PF=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
module.exports = _dereq_('./lib/heap');

},{"./lib/heap":2}],2:[function(_dereq_,module,exports){

(function() {
  var Heap, defaultCmp, floor, heapify, heappop, heappush, heappushpop, heapreplace, insort, min, nlargest, nsmallest, updateItem, _siftdown, _siftup;

  floor = Math.floor, min = Math.min;


  /*
  Default comparison function to be used
   */

  defaultCmp = function(x, y) {
    if (x < y) {
      return -1;
    }
    if (x > y) {
      return 1;
    }
    return 0;
  };


  /*
  Insert item x in list a, and keep it sorted assuming a is sorted.

  If x is already in a, insert it to the right of the rightmost x.

  Optional args lo (default 0) and hi (default a.length) bound the slice
  of a to be searched.
   */

  insort = function(a, x, lo, hi, cmp) {
    var mid;
    if (lo == null) {
      lo = 0;
    }
    if (cmp == null) {
      cmp = defaultCmp;
    }
    if (lo < 0) {
      throw new Error('lo must be non-negative');
    }
    if (hi == null) {
      hi = a.length;
    }
    while (lo < hi) {
      mid = floor((lo + hi) / 2);
      if (cmp(x, a[mid]) < 0) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }
    return ([].splice.apply(a, [lo, lo - lo].concat(x)), x);
  };


  /*
  Push item onto heap, maintaining the heap invariant.
   */

  heappush = function(array, item, cmp) {
    if (cmp == null) {
      cmp = defaultCmp;
    }
    array.push(item);
    return _siftdown(array, 0, array.length - 1, cmp);
  };


  /*
  Pop the smallest item off the heap, maintaining the heap invariant.
   */

  heappop = function(array, cmp) {
    var lastelt, returnitem;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    lastelt = array.pop();
    if (array.length) {
      returnitem = array[0];
      array[0] = lastelt;
      _siftup(array, 0, cmp);
    } else {
      returnitem = lastelt;
    }
    return returnitem;
  };


  /*
  Pop and return the current smallest value, and add the new item.

  This is more efficient than heappop() followed by heappush(), and can be
  more appropriate when using a fixed size heap. Note that the value
  returned may be larger than item! That constrains reasonable use of
  this routine unless written as part of a conditional replacement:
      if item > array[0]
        item = heapreplace(array, item)
   */

  heapreplace = function(array, item, cmp) {
    var returnitem;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    returnitem = array[0];
    array[0] = item;
    _siftup(array, 0, cmp);
    return returnitem;
  };


  /*
  Fast version of a heappush followed by a heappop.
   */

  heappushpop = function(array, item, cmp) {
    var _ref;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    if (array.length && cmp(array[0], item) < 0) {
      _ref = [array[0], item], item = _ref[0], array[0] = _ref[1];
      _siftup(array, 0, cmp);
    }
    return item;
  };


  /*
  Transform list into a heap, in-place, in O(array.length) time.
   */

  heapify = function(array, cmp) {
    var i, _i, _j, _len, _ref, _ref1, _results, _results1;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    _ref1 = (function() {
      _results1 = [];
      for (var _j = 0, _ref = floor(array.length / 2); 0 <= _ref ? _j < _ref : _j > _ref; 0 <= _ref ? _j++ : _j--){ _results1.push(_j); }
      return _results1;
    }).apply(this).reverse();
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      i = _ref1[_i];
      _results.push(_siftup(array, i, cmp));
    }
    return _results;
  };


  /*
  Update the position of the given item in the heap.
  This function should be called every time the item is being modified.
   */

  updateItem = function(array, item, cmp) {
    var pos;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    pos = array.indexOf(item);
    if (pos === -1) {
      return;
    }
    _siftdown(array, 0, pos, cmp);
    return _siftup(array, pos, cmp);
  };


  /*
  Find the n largest elements in a dataset.
   */

  nlargest = function(array, n, cmp) {
    var elem, result, _i, _len, _ref;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    result = array.slice(0, n);
    if (!result.length) {
      return result;
    }
    heapify(result, cmp);
    _ref = array.slice(n);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      elem = _ref[_i];
      heappushpop(result, elem, cmp);
    }
    return result.sort(cmp).reverse();
  };


  /*
  Find the n smallest elements in a dataset.
   */

  nsmallest = function(array, n, cmp) {
    var elem, i, los, result, _i, _j, _len, _ref, _ref1, _results;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    if (n * 10 <= array.length) {
      result = array.slice(0, n).sort(cmp);
      if (!result.length) {
        return result;
      }
      los = result[result.length - 1];
      _ref = array.slice(n);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        elem = _ref[_i];
        if (cmp(elem, los) < 0) {
          insort(result, elem, 0, null, cmp);
          result.pop();
          los = result[result.length - 1];
        }
      }
      return result;
    }
    heapify(array, cmp);
    _results = [];
    for (i = _j = 0, _ref1 = min(n, array.length); 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
      _results.push(heappop(array, cmp));
    }
    return _results;
  };

  _siftdown = function(array, startpos, pos, cmp) {
    var newitem, parent, parentpos;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    newitem = array[pos];
    while (pos > startpos) {
      parentpos = (pos - 1) >> 1;
      parent = array[parentpos];
      if (cmp(newitem, parent) < 0) {
        array[pos] = parent;
        pos = parentpos;
        continue;
      }
      break;
    }
    return array[pos] = newitem;
  };

  _siftup = function(array, pos, cmp) {
    var childpos, endpos, newitem, rightpos, startpos;
    if (cmp == null) {
      cmp = defaultCmp;
    }
    endpos = array.length;
    startpos = pos;
    newitem = array[pos];
    childpos = 2 * pos + 1;
    while (childpos < endpos) {
      rightpos = childpos + 1;
      if (rightpos < endpos && !(cmp(array[childpos], array[rightpos]) < 0)) {
        childpos = rightpos;
      }
      array[pos] = array[childpos];
      pos = childpos;
      childpos = 2 * pos + 1;
    }
    array[pos] = newitem;
    return _siftdown(array, startpos, pos, cmp);
  };

  Heap = (function() {
    Heap.push = heappush;

    Heap.pop = heappop;

    Heap.replace = heapreplace;

    Heap.pushpop = heappushpop;

    Heap.heapify = heapify;

    Heap.updateItem = updateItem;

    Heap.nlargest = nlargest;

    Heap.nsmallest = nsmallest;

    function Heap(cmp) {
      this.cmp = cmp != null ? cmp : defaultCmp;
      this.nodes = [];
    }

    Heap.prototype.push = function(x) {
      return heappush(this.nodes, x, this.cmp);
    };

    Heap.prototype.pop = function() {
      return heappop(this.nodes, this.cmp);
    };

    Heap.prototype.peek = function() {
      return this.nodes[0];
    };

    Heap.prototype.contains = function(x) {
      return this.nodes.indexOf(x) !== -1;
    };

    Heap.prototype.replace = function(x) {
      return heapreplace(this.nodes, x, this.cmp);
    };

    Heap.prototype.pushpop = function(x) {
      return heappushpop(this.nodes, x, this.cmp);
    };

    Heap.prototype.heapify = function() {
      return heapify(this.nodes, this.cmp);
    };

    Heap.prototype.updateItem = function(x) {
      return updateItem(this.nodes, x, this.cmp);
    };

    Heap.prototype.clear = function() {
      return this.nodes = [];
    };

    Heap.prototype.empty = function() {
      return this.nodes.length === 0;
    };

    Heap.prototype.size = function() {
      return this.nodes.length;
    };

    Heap.prototype.clone = function() {
      var heap;
      heap = new Heap();
      heap.nodes = this.nodes.slice(0);
      return heap;
    };

    Heap.prototype.toArray = function() {
      return this.nodes.slice(0);
    };

    Heap.prototype.insert = Heap.prototype.push;

    Heap.prototype.top = Heap.prototype.peek;

    Heap.prototype.front = Heap.prototype.peek;

    Heap.prototype.has = Heap.prototype.contains;

    Heap.prototype.copy = Heap.prototype.clone;

    return Heap;

  })();

  if (typeof module !== "undefined" && module !== null ? module.exports : void 0) {
    module.exports = Heap;
  } else {
    window.Heap = Heap;
  }

}).call(this);

},{}],3:[function(_dereq_,module,exports){
var DiagonalMovement = {
    Always: 1,
    Never: 2,
    IfAtMostOneObstacle: 3,
    OnlyWhenNoObstacles: 4
};

module.exports = DiagonalMovement;
},{}],4:[function(_dereq_,module,exports){
var Node = _dereq_('./Node');
var DiagonalMovement = _dereq_('./DiagonalMovement');

/**
 * The Grid class, which serves as the encapsulation of the layout of the nodes.
 * @constructor
 * @param {number|Array<Array<(number|boolean)>>} width_or_matrix Number of columns of the grid, or matrix
 * @param {number} height Number of rows of the grid.
 * @param {Array<Array<(number|boolean)>>} [matrix] - A 0-1 matrix
 *     representing the walkable status of the nodes(0 or false for walkable).
 *     If the matrix is not supplied, all the nodes will be walkable.  */
function Grid(width_or_matrix, height, matrix) {
    var width;

    if (typeof width_or_matrix !== 'object') {
        width = width_or_matrix;
    } else {
        height = width_or_matrix.length;
        width = width_or_matrix[0].length;
        matrix = width_or_matrix;
    }

    /**
     * The number of columns of the grid.
     * @type number
     */
    this.width = width;
    /**
     * The number of rows of the grid.
     * @type number
     */
    this.height = height;

    /**
     * A 2D array of nodes.
     */
    this.nodes = this._buildNodes(width, height, matrix);
}

/**
 * Build and return the nodes.
 * @private
 * @param {number} width
 * @param {number} height
 * @param {Array<Array<number|boolean>>} [matrix] - A 0-1 matrix representing
 *     the walkable status of the nodes.
 * @see Grid
 */
Grid.prototype._buildNodes = function(width, height, matrix) {
    var i, j,
        nodes = new Array(height);

    for (i = 0; i < height; ++i) {
        nodes[i] = new Array(width);
        for (j = 0; j < width; ++j) {
            nodes[i][j] = new Node(j, i);
        }
    }


    if (matrix === undefined) {
        return nodes;
    }

    if (matrix.length !== height || matrix[0].length !== width) {
        throw new Error('Matrix size does not fit');
    }

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            if (matrix[i][j]) {
                // 0, false, null will be walkable
                // while others will be un-walkable
                nodes[i][j].walkable = false;
            }
        }
    }

    return nodes;
};


Grid.prototype.getNodeAt = function(x, y) {
    return this.nodes[y][x];
};


/**
 * Determine whether the node at the given position is walkable.
 * (Also returns false if the position is outside the grid.)
 * @param {number} x - The x coordinate of the node.
 * @param {number} y - The y coordinate of the node.
 * @return {boolean} - The walkability of the node.
 */
Grid.prototype.isWalkableAt = function(x, y) {
    return this.isInside(x, y) && this.nodes[y][x].walkable;
};


/**
 * Determine whether the position is inside the grid.
 * XXX: grid.isInside(x, y) is wierd to read.
 * It should be (x, y) is inside grid, but I failed to find a better
 * name for this method.
 * @param {number} x
 * @param {number} y
 * @return {boolean}
 */
Grid.prototype.isInside = function(x, y) {
    return (x >= 0 && x < this.width) && (y >= 0 && y < this.height);
};


/**
 * Set whether the node on the given position is walkable.
 * NOTE: throws exception if the coordinate is not inside the grid.
 * @param {number} x - The x coordinate of the node.
 * @param {number} y - The y coordinate of the node.
 * @param {boolean} walkable - Whether the position is walkable.
 */
Grid.prototype.setWalkableAt = function(x, y, walkable) {
    this.nodes[y][x].walkable = walkable;
};


/**
 * Get the neighbors of the given node.
 *
 *     offsets      diagonalOffsets:
 *  +---+---+---+    +---+---+---+
 *  |   | 0 |   |    | 0 |   | 1 |
 *  +---+---+---+    +---+---+---+
 *  | 3 |   | 1 |    |   |   |   |
 *  +---+---+---+    +---+---+---+
 *  |   | 2 |   |    | 3 |   | 2 |
 *  +---+---+---+    +---+---+---+
 *
 *  When allowDiagonal is true, if offsets[i] is valid, then
 *  diagonalOffsets[i] and
 *  diagonalOffsets[(i + 1) % 4] is valid.
 * @param {Node} node
 * @param {DiagonalMovement} diagonalMovement
 */
Grid.prototype.getNeighbors = function(node, diagonalMovement) {
    var x = node.x,
        y = node.y,
        neighbors = [],
        s0 = false, d0 = false,
        s1 = false, d1 = false,
        s2 = false, d2 = false,
        s3 = false, d3 = false,
        nodes = this.nodes;

    // ↑
    if (this.isWalkableAt(x, y - 1)) {
        neighbors.push(nodes[y - 1][x]);
        s0 = true;
    }
    // →
    if (this.isWalkableAt(x + 1, y)) {
        neighbors.push(nodes[y][x + 1]);
        s1 = true;
    }
    // ↓
    if (this.isWalkableAt(x, y + 1)) {
        neighbors.push(nodes[y + 1][x]);
        s2 = true;
    }
    // ←
    if (this.isWalkableAt(x - 1, y)) {
        neighbors.push(nodes[y][x - 1]);
        s3 = true;
    }

    if (diagonalMovement === DiagonalMovement.Never) {
        return neighbors;
    }

    if (diagonalMovement === DiagonalMovement.OnlyWhenNoObstacles) {
        d0 = s3 && s0;
        d1 = s0 && s1;
        d2 = s1 && s2;
        d3 = s2 && s3;
    } else if (diagonalMovement === DiagonalMovement.IfAtMostOneObstacle) {
        d0 = s3 || s0;
        d1 = s0 || s1;
        d2 = s1 || s2;
        d3 = s2 || s3;
    } else if (diagonalMovement === DiagonalMovement.Always) {
        d0 = true;
        d1 = true;
        d2 = true;
        d3 = true;
    } else {
        throw new Error('Incorrect value of diagonalMovement');
    }

    // ↖
    if (d0 && this.isWalkableAt(x - 1, y - 1)) {
        neighbors.push(nodes[y - 1][x - 1]);
    }
    // ↗
    if (d1 && this.isWalkableAt(x + 1, y - 1)) {
        neighbors.push(nodes[y - 1][x + 1]);
    }
    // ↘
    if (d2 && this.isWalkableAt(x + 1, y + 1)) {
        neighbors.push(nodes[y + 1][x + 1]);
    }
    // ↙
    if (d3 && this.isWalkableAt(x - 1, y + 1)) {
        neighbors.push(nodes[y + 1][x - 1]);
    }

    return neighbors;
};


/**
 * Get a clone of this grid.
 * @return {Grid} Cloned grid.
 */
Grid.prototype.clone = function() {
    var i, j,

        width = this.width,
        height = this.height,
        thisNodes = this.nodes,

        newGrid = new Grid(width, height),
        newNodes = new Array(height);

    for (i = 0; i < height; ++i) {
        newNodes[i] = new Array(width);
        for (j = 0; j < width; ++j) {
            newNodes[i][j] = new Node(j, i, thisNodes[i][j].walkable);
        }
    }

    newGrid.nodes = newNodes;

    return newGrid;
};

module.exports = Grid;

},{"./DiagonalMovement":3,"./Node":6}],5:[function(_dereq_,module,exports){
/**
 * @namespace PF.Heuristic
 * @description A collection of heuristic functions.
 */
module.exports = {

  /**
   * Manhattan distance.
   * @param {number} dx - Difference in x.
   * @param {number} dy - Difference in y.
   * @return {number} dx + dy
   */
  manhattan: function(dx, dy) {
      return dx + dy;
  },

  /**
   * Euclidean distance.
   * @param {number} dx - Difference in x.
   * @param {number} dy - Difference in y.
   * @return {number} sqrt(dx * dx + dy * dy)
   */
  euclidean: function(dx, dy) {
      return Math.sqrt(dx * dx + dy * dy);
  },

  /**
   * Octile distance.
   * @param {number} dx - Difference in x.
   * @param {number} dy - Difference in y.
   * @return {number} sqrt(dx * dx + dy * dy) for grids
   */
  octile: function(dx, dy) {
      var F = Math.SQRT2 - 1;
      return (dx < dy) ? F * dx + dy : F * dy + dx;
  },

  /**
   * Chebyshev distance.
   * @param {number} dx - Difference in x.
   * @param {number} dy - Difference in y.
   * @return {number} max(dx, dy)
   */
  chebyshev: function(dx, dy) {
      return Math.max(dx, dy);
  }

};

},{}],6:[function(_dereq_,module,exports){
/**
 * A node in grid.
 * This class holds some basic information about a node and custom
 * attributes may be added, depending on the algorithms' needs.
 * @constructor
 * @param {number} x - The x coordinate of the node on the grid.
 * @param {number} y - The y coordinate of the node on the grid.
 * @param {boolean} [walkable] - Whether this node is walkable.
 */
function Node(x, y, walkable) {
    /**
     * The x coordinate of the node on the grid.
     * @type number
     */
    this.x = x;
    /**
     * The y coordinate of the node on the grid.
     * @type number
     */
    this.y = y;
    /**
     * Whether this node can be walked through.
     * @type boolean
     */
    this.walkable = (walkable === undefined ? true : walkable);
}

module.exports = Node;

},{}],7:[function(_dereq_,module,exports){
/**
 * Backtrace according to the parent records and return the path.
 * (including both start and end nodes)
 * @param {Node} node End node
 * @return {Array<Array<number>>} the path
 */
function backtrace(node) {
    var path = [[node.x, node.y]];
    while (node.parent) {
        node = node.parent;
        path.push([node.x, node.y]);
    }
    return path.reverse();
}
exports.backtrace = backtrace;

/**
 * Backtrace from start and end node, and return the path.
 * (including both start and end nodes)
 * @param {Node}
 * @param {Node}
 */
function biBacktrace(nodeA, nodeB) {
    var pathA = backtrace(nodeA),
        pathB = backtrace(nodeB);
    return pathA.concat(pathB.reverse());
}
exports.biBacktrace = biBacktrace;

/**
 * Compute the length of the path.
 * @param {Array<Array<number>>} path The path
 * @return {number} The length of the path
 */
function pathLength(path) {
    var i, sum = 0, a, b, dx, dy;
    for (i = 1; i < path.length; ++i) {
        a = path[i - 1];
        b = path[i];
        dx = a[0] - b[0];
        dy = a[1] - b[1];
        sum += Math.sqrt(dx * dx + dy * dy);
    }
    return sum;
}
exports.pathLength = pathLength;


/**
 * Given the start and end coordinates, return all the coordinates lying
 * on the line formed by these coordinates, based on Bresenham's algorithm.
 * http://en.wikipedia.org/wiki/Bresenham's_line_algorithm#Simplification
 * @param {number} x0 Start x coordinate
 * @param {number} y0 Start y coordinate
 * @param {number} x1 End x coordinate
 * @param {number} y1 End y coordinate
 * @return {Array<Array<number>>} The coordinates on the line
 */
function interpolate(x0, y0, x1, y1) {
    var abs = Math.abs,
        line = [],
        sx, sy, dx, dy, err, e2;

    dx = abs(x1 - x0);
    dy = abs(y1 - y0);

    sx = (x0 < x1) ? 1 : -1;
    sy = (y0 < y1) ? 1 : -1;

    err = dx - dy;

    while (true) {
        line.push([x0, y0]);

        if (x0 === x1 && y0 === y1) {
            break;
        }

        e2 = 2 * err;
        if (e2 > -dy) {
            err = err - dy;
            x0 = x0 + sx;
        }
        if (e2 < dx) {
            err = err + dx;
            y0 = y0 + sy;
        }
    }

    return line;
}
exports.interpolate = interpolate;


/**
 * Given a compressed path, return a new path that has all the segments
 * in it interpolated.
 * @param {Array<Array<number>>} path The path
 * @return {Array<Array<number>>} expanded path
 */
function expandPath(path) {
    var expanded = [],
        len = path.length,
        coord0, coord1,
        interpolated,
        interpolatedLen,
        i, j;

    if (len < 2) {
        return expanded;
    }

    for (i = 0; i < len - 1; ++i) {
        coord0 = path[i];
        coord1 = path[i + 1];

        interpolated = interpolate(coord0[0], coord0[1], coord1[0], coord1[1]);
        interpolatedLen = interpolated.length;
        for (j = 0; j < interpolatedLen - 1; ++j) {
            expanded.push(interpolated[j]);
        }
    }
    expanded.push(path[len - 1]);

    return expanded;
}
exports.expandPath = expandPath;


/**
 * Smoothen the give path.
 * The original path will not be modified; a new path will be returned.
 * @param {PF.Grid} grid
 * @param {Array<Array<number>>} path The path
 */
function smoothenPath(grid, path) {
    var len = path.length,
        x0 = path[0][0],        // path start x
        y0 = path[0][1],        // path start y
        x1 = path[len - 1][0],  // path end x
        y1 = path[len - 1][1],  // path end y
        sx, sy,                 // current start coordinate
        ex, ey,                 // current end coordinate
        newPath,
        i, j, coord, line, testCoord, blocked;

    sx = x0;
    sy = y0;
    newPath = [[sx, sy]];

    for (i = 2; i < len; ++i) {
        coord = path[i];
        ex = coord[0];
        ey = coord[1];
        line = interpolate(sx, sy, ex, ey);

        blocked = false;
        for (j = 1; j < line.length; ++j) {
            testCoord = line[j];

            if (!grid.isWalkableAt(testCoord[0], testCoord[1])) {
                blocked = true;
                break;
            }
        }
        if (blocked) {
            lastValidCoord = path[i - 1];
            newPath.push(lastValidCoord);
            sx = lastValidCoord[0];
            sy = lastValidCoord[1];
        }
    }
    newPath.push([x1, y1]);

    return newPath;
}
exports.smoothenPath = smoothenPath;


/**
 * Compress a path, remove redundant nodes without altering the shape
 * The original path is not modified
 * @param {Array<Array<number>>} path The path
 * @return {Array<Array<number>>} The compressed path
 */
function compressPath(path) {

    // nothing to compress
    if(path.length < 3) {
        return path;
    }

    var compressed = [],
        sx = path[0][0], // start x
        sy = path[0][1], // start y
        px = path[1][0], // second point x
        py = path[1][1], // second point y
        dx = px - sx, // direction between the two points
        dy = py - sy, // direction between the two points
        lx, ly,
        ldx, ldy,
        sq, i;

    // normalize the direction
    sq = Math.sqrt(dx*dx + dy*dy);
    dx /= sq;
    dy /= sq;

    // start the new path
    compressed.push([sx,sy]);

    for(i = 2; i < path.length; i++) {

        // store the last point
        lx = px;
        ly = py;

        // store the last direction
        ldx = dx;
        ldy = dy;

        // next point
        px = path[i][0];
        py = path[i][1];

        // next direction
        dx = px - lx;
        dy = py - ly;

        // normalize
        sq = Math.sqrt(dx*dx + dy*dy);
        dx /= sq;
        dy /= sq;

        // if the direction has changed, store the point
        if ( dx !== ldx || dy !== ldy ) {
            compressed.push([lx,ly]);
        }
    }

    // store the last point
    compressed.push([px,py]);

    return compressed;
}
exports.compressPath = compressPath;

},{}],8:[function(_dereq_,module,exports){
module.exports = {
    'Heap'                      : _dereq_('heap'),
    'Node'                      : _dereq_('./core/Node'),
    'Grid'                      : _dereq_('./core/Grid'),
    'Util'                      : _dereq_('./core/Util'),
    'DiagonalMovement'          : _dereq_('./core/DiagonalMovement'),
    'Heuristic'                 : _dereq_('./core/Heuristic'),
    'AStarFinder'               : _dereq_('./finders/AStarFinder'),
    'BestFirstFinder'           : _dereq_('./finders/BestFirstFinder'),
    'BreadthFirstFinder'        : _dereq_('./finders/BreadthFirstFinder'),
    'DijkstraFinder'            : _dereq_('./finders/DijkstraFinder'),
    'BiAStarFinder'             : _dereq_('./finders/BiAStarFinder'),
    'BiBestFirstFinder'         : _dereq_('./finders/BiBestFirstFinder'),
    'BiBreadthFirstFinder'      : _dereq_('./finders/BiBreadthFirstFinder'),
    'BiDijkstraFinder'          : _dereq_('./finders/BiDijkstraFinder'),
    'IDAStarFinder'             : _dereq_('./finders/IDAStarFinder'),
    'JumpPointFinder'           : _dereq_('./finders/JumpPointFinder'),
};

},{"./core/DiagonalMovement":3,"./core/Grid":4,"./core/Heuristic":5,"./core/Node":6,"./core/Util":7,"./finders/AStarFinder":9,"./finders/BestFirstFinder":10,"./finders/BiAStarFinder":11,"./finders/BiBestFirstFinder":12,"./finders/BiBreadthFirstFinder":13,"./finders/BiDijkstraFinder":14,"./finders/BreadthFirstFinder":15,"./finders/DijkstraFinder":16,"./finders/IDAStarFinder":17,"./finders/JumpPointFinder":22,"heap":1}],9:[function(_dereq_,module,exports){
var Heap       = _dereq_('heap');
var Util       = _dereq_('../core/Util');
var Heuristic  = _dereq_('../core/Heuristic');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * A* path-finder. Based upon https://github.com/bgrins/javascript-astar
 * @constructor
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 * @param {number} opt.weight Weight to apply to the heuristic to allow for
 *     suboptimal paths, in order to speed up the search.
 */
function AStarFinder(opt) {
    opt = opt || {};
    this.allowDiagonal = opt.allowDiagonal;
    this.dontCrossCorners = opt.dontCrossCorners;
    this.heuristic = opt.heuristic || Heuristic.manhattan;
    this.weight = opt.weight || 1;
    this.diagonalMovement = opt.diagonalMovement;

    if (!this.diagonalMovement) {
        if (!this.allowDiagonal) {
            this.diagonalMovement = DiagonalMovement.Never;
        } else {
            if (this.dontCrossCorners) {
                this.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;
            } else {
                this.diagonalMovement = DiagonalMovement.IfAtMostOneObstacle;
            }
        }
    }

    // When diagonal movement is allowed the manhattan heuristic is not
    //admissible. It should be octile instead
    if (this.diagonalMovement === DiagonalMovement.Never) {
        this.heuristic = opt.heuristic || Heuristic.manhattan;
    } else {
        this.heuristic = opt.heuristic || Heuristic.octile;
    }
}

/**
 * Find and return the the path.
 * @return {Array<Array<number>>} The path, including both start and
 *     end positions.
 */
AStarFinder.prototype.findPath = function(startX, startY, endX, endY, grid) {
    var openList = new Heap(function(nodeA, nodeB) {
            return nodeA.f - nodeB.f;
        }),
        startNode = grid.getNodeAt(startX, startY),
        endNode = grid.getNodeAt(endX, endY),
        heuristic = this.heuristic,
        diagonalMovement = this.diagonalMovement,
        weight = this.weight,
        abs = Math.abs, SQRT2 = Math.SQRT2,
        node, neighbors, neighbor, i, l, x, y, ng;

    // set the g and f value of the start node to be 0
    startNode.g = 0;
    startNode.f = 0;

    // push the start node into the open list
    openList.push(startNode);
    startNode.opened = true;

    // while the open list is not empty
    while (!openList.empty()) {
        // pop the position of node which has the minimum f value.
        node = openList.pop();
        node.closed = true;

        // if reached the end position, construct the path and return it
        if (node === endNode) {
            return Util.backtrace(endNode);
        }

        // get neigbours of the current node
        neighbors = grid.getNeighbors(node, diagonalMovement);
        for (i = 0, l = neighbors.length; i < l; ++i) {
            neighbor = neighbors[i];

            if (neighbor.closed) {
                continue;
            }

            x = neighbor.x;
            y = neighbor.y;

            // get the distance between current node and the neighbor
            // and calculate the next g score
            ng = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);

            // check if the neighbor has not been inspected yet, or
            // can be reached with smaller cost from the current node
            if (!neighbor.opened || ng < neighbor.g) {
                neighbor.g = ng;
                neighbor.h = neighbor.h || weight * heuristic(abs(x - endX), abs(y - endY));
                neighbor.f = neighbor.g + neighbor.h;
                neighbor.parent = node;

                if (!neighbor.opened) {
                    openList.push(neighbor);
                    neighbor.opened = true;
                } else {
                    // the neighbor can be reached with smaller cost.
                    // Since its f value has been updated, we have to
                    // update its position in the open list
                    openList.updateItem(neighbor);
                }
            }
        } // end for each neighbor
    } // end while not open list empty

    // fail to find the path
    return [];
};

module.exports = AStarFinder;

},{"../core/DiagonalMovement":3,"../core/Heuristic":5,"../core/Util":7,"heap":1}],10:[function(_dereq_,module,exports){
var AStarFinder = _dereq_('./AStarFinder');

/**
 * Best-First-Search path-finder.
 * @constructor
 * @extends AStarFinder
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
function BestFirstFinder(opt) {
    AStarFinder.call(this, opt);

    var orig = this.heuristic;
    this.heuristic = function(dx, dy) {
        return orig(dx, dy) * 1000000;
    };
}

BestFirstFinder.prototype = new AStarFinder();
BestFirstFinder.prototype.constructor = BestFirstFinder;

module.exports = BestFirstFinder;

},{"./AStarFinder":9}],11:[function(_dereq_,module,exports){
var Heap       = _dereq_('heap');
var Util       = _dereq_('../core/Util');
var Heuristic  = _dereq_('../core/Heuristic');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * A* path-finder.
 * based upon https://github.com/bgrins/javascript-astar
 * @constructor
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 * @param {number} opt.weight Weight to apply to the heuristic to allow for
 *     suboptimal paths, in order to speed up the search.
 */
function BiAStarFinder(opt) {
    opt = opt || {};
    this.allowDiagonal = opt.allowDiagonal;
    this.dontCrossCorners = opt.dontCrossCorners;
    this.diagonalMovement = opt.diagonalMovement;
    this.heuristic = opt.heuristic || Heuristic.manhattan;
    this.weight = opt.weight || 1;

    if (!this.diagonalMovement) {
        if (!this.allowDiagonal) {
            this.diagonalMovement = DiagonalMovement.Never;
        } else {
            if (this.dontCrossCorners) {
                this.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;
            } else {
                this.diagonalMovement = DiagonalMovement.IfAtMostOneObstacle;
            }
        }
    }

    //When diagonal movement is allowed the manhattan heuristic is not admissible
    //It should be octile instead
    if (this.diagonalMovement === DiagonalMovement.Never) {
        this.heuristic = opt.heuristic || Heuristic.manhattan;
    } else {
        this.heuristic = opt.heuristic || Heuristic.octile;
    }
}

/**
 * Find and return the the path.
 * @return {Array<Array<number>>} The path, including both start and
 *     end positions.
 */
BiAStarFinder.prototype.findPath = function(startX, startY, endX, endY, grid) {
    var cmp = function(nodeA, nodeB) {
            return nodeA.f - nodeB.f;
        },
        startOpenList = new Heap(cmp),
        endOpenList = new Heap(cmp),
        startNode = grid.getNodeAt(startX, startY),
        endNode = grid.getNodeAt(endX, endY),
        heuristic = this.heuristic,
        diagonalMovement = this.diagonalMovement,
        weight = this.weight,
        abs = Math.abs, SQRT2 = Math.SQRT2,
        node, neighbors, neighbor, i, l, x, y, ng,
        BY_START = 1, BY_END = 2;

    // set the  and  value of the start node to be 0
    // and push it into the start open list
    startNode.g = 0;
    startNode.f = 0;
    startOpenList.push(startNode);
    startNode.opened = BY_START;

    // set theand value of the end node to be 0
    // and push it into the open open list
    endNode.g = 0;
    endNode.f = 0;
    endOpenList.push(endNode);
    endNode.opened = BY_END;

    // while both the open lists are not empty
    while (!startOpenList.empty() && !endOpenList.empty()) {


        node = startOpenList.pop();
        node.closed = true;

        // get neigbours of the current node
        neighbors = grid.getNeighbors(node, diagonalMovement);
        for (i = 0, l = neighbors.length; i < l; ++i) {
            neighbor = neighbors[i];

            if (neighbor.closed) {
                continue;
            }
            if (neighbor.opened === BY_END) {
                return Util.biBacktrace(node, neighbor);
            }

            x = neighbor.x;
            y = neighbor.y;

            // get the distance between current node and the neighbor
            // and calculate the next g score
            ng = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);

            // check if the neighbor has not been inspected yet, or
            // can be reached with smaller cost from the current node
            if (!neighbor.opened || ng < neighbor.g) {
                neighbor.g = ng;
                neighbor.h = neighbor.h ||
                    weight * heuristic(abs(x - endX), abs(y - endY));
                neighbor.f = neighbor.g + neighbor.h;
                neighbor.parent = node;

                if (!neighbor.opened) {
                    startOpenList.push(neighbor);
                    neighbor.opened = BY_START;
                } else {
                    // the neighbor can be reached with smaller cost.
                    // Since its f value has been updated, we have to
                    // update its position in the open list
                    startOpenList.updateItem(neighbor);
                }
            }
        } // end for each neighbor


        // pop the position of end node which has the
        node = endOpenList.pop();
        node.closed = true;

        // get neigbours of the current node
        neighbors = grid.getNeighbors(node, diagonalMovement);
        for (i = 0, l = neighbors.length; i < l; ++i) {
            neighbor = neighbors[i];

            if (neighbor.closed) {
                continue;
            }
            if (neighbor.opened === BY_START) {
                return Util.biBacktrace(neighbor, node);
            }

            x = neighbor.x;
            y = neighbor.y;

            // get the distance between current node and the neighbor
            // and calculate the next g score
            ng = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);

            // check if the neighbor has not been inspected yet, or
            // can be reached with smaller cost from the current node
            if (!neighbor.opened || ng < neighbor.g) {
                neighbor.g = ng;
                neighbor.h = neighbor.h ||
                    weight * heuristic(abs(x - startX), abs(y - startY));
                neighbor.f = neighbor.g + neighbor.h;
                neighbor.parent = node;

                if (!neighbor.opened) {
                    endOpenList.push(neighbor);
                    neighbor.opened = BY_END;
                } else {
                    // the neighbor can be reached with smaller cost.
                    // Since its f value has been updated, we have to
                    // update its position in the open list
                    endOpenList.updateItem(neighbor);
                }
            }
        } // end for each neighbor
    } // end while not open list empty

    // fail to find the path
    return [];
};

module.exports = BiAStarFinder;

},{"../core/DiagonalMovement":3,"../core/Heuristic":5,"../core/Util":7,"heap":1}],12:[function(_dereq_,module,exports){
var BiAStarFinder = _dereq_('./BiAStarFinder');

/**
 * Bi-direcitional Best-First-Search path-finder.
 * @constructor
 * @extends BiAStarFinder
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
function BiBestFirstFinder(opt) {
    BiAStarFinder.call(this, opt);

    var orig = this.heuristic;
    this.heuristic = function(dx, dy) {
        return orig(dx, dy) * 1000000;
    };
}

BiBestFirstFinder.prototype = new BiAStarFinder();
BiBestFirstFinder.prototype.constructor = BiBestFirstFinder;

module.exports = BiBestFirstFinder;

},{"./BiAStarFinder":11}],13:[function(_dereq_,module,exports){
var Util = _dereq_('../core/Util');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Bi-directional Breadth-First-Search path finder.
 * @constructor
 * @param {object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 */
function BiBreadthFirstFinder(opt) {
    opt = opt || {};
    this.allowDiagonal = opt.allowDiagonal;
    this.dontCrossCorners = opt.dontCrossCorners;
    this.diagonalMovement = opt.diagonalMovement;

    if (!this.diagonalMovement) {
        if (!this.allowDiagonal) {
            this.diagonalMovement = DiagonalMovement.Never;
        } else {
            if (this.dontCrossCorners) {
                this.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;
            } else {
                this.diagonalMovement = DiagonalMovement.IfAtMostOneObstacle;
            }
        }
    }
}


/**
 * Find and return the the path.
 * @return {Array<Array<number>>} The path, including both start and
 *     end positions.
 */
BiBreadthFirstFinder.prototype.findPath = function(startX, startY, endX, endY, grid) {
    var startNode = grid.getNodeAt(startX, startY),
        endNode = grid.getNodeAt(endX, endY),
        startOpenList = [], endOpenList = [],
        neighbors, neighbor, node,
        diagonalMovement = this.diagonalMovement,
        BY_START = 0, BY_END = 1,
        i, l;

    // push the start and end nodes into the queues
    startOpenList.push(startNode);
    startNode.opened = true;
    startNode.by = BY_START;

    endOpenList.push(endNode);
    endNode.opened = true;
    endNode.by = BY_END;

    // while both the queues are not empty
    while (startOpenList.length && endOpenList.length) {

        // expand start open list

        node = startOpenList.shift();
        node.closed = true;

        neighbors = grid.getNeighbors(node, diagonalMovement);
        for (i = 0, l = neighbors.length; i < l; ++i) {
            neighbor = neighbors[i];

            if (neighbor.closed) {
                continue;
            }
            if (neighbor.opened) {
                // if this node has been inspected by the reversed search,
                // then a path is found.
                if (neighbor.by === BY_END) {
                    return Util.biBacktrace(node, neighbor);
                }
                continue;
            }
            startOpenList.push(neighbor);
            neighbor.parent = node;
            neighbor.opened = true;
            neighbor.by = BY_START;
        }

        // expand end open list

        node = endOpenList.shift();
        node.closed = true;

        neighbors = grid.getNeighbors(node, diagonalMovement);
        for (i = 0, l = neighbors.length; i < l; ++i) {
            neighbor = neighbors[i];

            if (neighbor.closed) {
                continue;
            }
            if (neighbor.opened) {
                if (neighbor.by === BY_START) {
                    return Util.biBacktrace(neighbor, node);
                }
                continue;
            }
            endOpenList.push(neighbor);
            neighbor.parent = node;
            neighbor.opened = true;
            neighbor.by = BY_END;
        }
    }

    // fail to find the path
    return [];
};

module.exports = BiBreadthFirstFinder;

},{"../core/DiagonalMovement":3,"../core/Util":7}],14:[function(_dereq_,module,exports){
var BiAStarFinder = _dereq_('./BiAStarFinder');

/**
 * Bi-directional Dijkstra path-finder.
 * @constructor
 * @extends BiAStarFinder
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 */
function BiDijkstraFinder(opt) {
    BiAStarFinder.call(this, opt);
    this.heuristic = function(dx, dy) {
        return 0;
    };
}

BiDijkstraFinder.prototype = new BiAStarFinder();
BiDijkstraFinder.prototype.constructor = BiDijkstraFinder;

module.exports = BiDijkstraFinder;

},{"./BiAStarFinder":11}],15:[function(_dereq_,module,exports){
var Util = _dereq_('../core/Util');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Breadth-First-Search path finder.
 * @constructor
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 */
function BreadthFirstFinder(opt) {
    opt = opt || {};
    this.allowDiagonal = opt.allowDiagonal;
    this.dontCrossCorners = opt.dontCrossCorners;
    this.diagonalMovement = opt.diagonalMovement;

    if (!this.diagonalMovement) {
        if (!this.allowDiagonal) {
            this.diagonalMovement = DiagonalMovement.Never;
        } else {
            if (this.dontCrossCorners) {
                this.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;
            } else {
                this.diagonalMovement = DiagonalMovement.IfAtMostOneObstacle;
            }
        }
    }
}

/**
 * Find and return the the path.
 * @return {Array<Array<number>>} The path, including both start and
 *     end positions.
 */
BreadthFirstFinder.prototype.findPath = function(startX, startY, endX, endY, grid) {
    var openList = [],
        diagonalMovement = this.diagonalMovement,
        startNode = grid.getNodeAt(startX, startY),
        endNode = grid.getNodeAt(endX, endY),
        neighbors, neighbor, node, i, l;

    // push the start pos into the queue
    openList.push(startNode);
    startNode.opened = true;

    // while the queue is not empty
    while (openList.length) {
        // take the front node from the queue
        node = openList.shift();
        node.closed = true;

        // reached the end position
        if (node === endNode) {
            return Util.backtrace(endNode);
        }

        neighbors = grid.getNeighbors(node, diagonalMovement);
        for (i = 0, l = neighbors.length; i < l; ++i) {
            neighbor = neighbors[i];

            // skip this neighbor if it has been inspected before
            if (neighbor.closed || neighbor.opened) {
                continue;
            }

            openList.push(neighbor);
            neighbor.opened = true;
            neighbor.parent = node;
        }
    }

    // fail to find the path
    return [];
};

module.exports = BreadthFirstFinder;

},{"../core/DiagonalMovement":3,"../core/Util":7}],16:[function(_dereq_,module,exports){
var AStarFinder = _dereq_('./AStarFinder');

/**
 * Dijkstra path-finder.
 * @constructor
 * @extends AStarFinder
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 */
function DijkstraFinder(opt) {
    AStarFinder.call(this, opt);
    this.heuristic = function(dx, dy) {
        return 0;
    };
}

DijkstraFinder.prototype = new AStarFinder();
DijkstraFinder.prototype.constructor = DijkstraFinder;

module.exports = DijkstraFinder;

},{"./AStarFinder":9}],17:[function(_dereq_,module,exports){
var Util       = _dereq_('../core/Util');
var Heuristic  = _dereq_('../core/Heuristic');
var Node       = _dereq_('../core/Node');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Iterative Deeping A Star (IDA*) path-finder.
 *
 * Recursion based on:
 *   http://www.apl.jhu.edu/~hall/AI-Programming/IDA-Star.html
 *
 * Path retracing based on:
 *  V. Nageshwara Rao, Vipin Kumar and K. Ramesh
 *  "A Parallel Implementation of Iterative-Deeping-A*", January 1987.
 *  ftp://ftp.cs.utexas.edu/.snapshot/hourly.1/pub/AI-Lab/tech-reports/UT-AI-TR-87-46.pdf
 *
 * @author Gerard Meier (www.gerardmeier.com)
 *
 * @constructor
 * @param {Object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
 *     Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
 *     block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 * @param {number} opt.weight Weight to apply to the heuristic to allow for
 *     suboptimal paths, in order to speed up the search.
 * @param {boolean} opt.trackRecursion Whether to track recursion for
 *     statistical purposes.
 * @param {number} opt.timeLimit Maximum execution time. Use <= 0 for infinite.
 */
function IDAStarFinder(opt) {
    opt = opt || {};
    this.allowDiagonal = opt.allowDiagonal;
    this.dontCrossCorners = opt.dontCrossCorners;
    this.diagonalMovement = opt.diagonalMovement;
    this.heuristic = opt.heuristic || Heuristic.manhattan;
    this.weight = opt.weight || 1;
    this.trackRecursion = opt.trackRecursion || false;
    this.timeLimit = opt.timeLimit || Infinity; // Default: no time limit.

    if (!this.diagonalMovement) {
        if (!this.allowDiagonal) {
            this.diagonalMovement = DiagonalMovement.Never;
        } else {
            if (this.dontCrossCorners) {
                this.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;
            } else {
                this.diagonalMovement = DiagonalMovement.IfAtMostOneObstacle;
            }
        }
    }

    // When diagonal movement is allowed the manhattan heuristic is not
    // admissible, it should be octile instead
    if (this.diagonalMovement === DiagonalMovement.Never) {
        this.heuristic = opt.heuristic || Heuristic.manhattan;
    } else {
        this.heuristic = opt.heuristic || Heuristic.octile;
    }
}

/**
 * Find and return the the path. When an empty array is returned, either
 * no path is possible, or the maximum execution time is reached.
 *
 * @return {Array<Array<number>>} The path, including both start and
 *     end positions.
 */
IDAStarFinder.prototype.findPath = function(startX, startY, endX, endY, grid) {
    // Used for statistics:
    var nodesVisited = 0;

    // Execution time limitation:
    var startTime = new Date().getTime();

    // Heuristic helper:
    var h = function(a, b) {
        return this.heuristic(Math.abs(b.x - a.x), Math.abs(b.y - a.y));
    }.bind(this);

    // Step cost from a to b:
    var cost = function(a, b) {
        return (a.x === b.x || a.y === b.y) ? 1 : Math.SQRT2;
    };

    /**
     * IDA* search implementation.
     *
     * @param {Node} The node currently expanding from.
     * @param {number} Cost to reach the given node.
     * @param {number} Maximum search depth (cut-off value).
     * @param {Array<Array<number>>} The found route.
     * @param {number} Recursion depth.
     *
     * @return {Object} either a number with the new optimal cut-off depth,
     * or a valid node instance, in which case a path was found.
     */
    var search = function(node, g, cutoff, route, depth) {
        nodesVisited++;

        // Enforce timelimit:
        if (this.timeLimit > 0 &&
            new Date().getTime() - startTime > this.timeLimit * 1000) {
            // Enforced as "path-not-found".
            return Infinity;
        }

        var f = g + h(node, end) * this.weight;

        // We've searched too deep for this iteration.
        if (f > cutoff) {
            return f;
        }

        if (node == end) {
            route[depth] = [node.x, node.y];
            return node;
        }

        var min, t, k, neighbour;

        var neighbours = grid.getNeighbors(node, this.diagonalMovement);

        // Sort the neighbours, gives nicer paths. But, this deviates
        // from the original algorithm - so I left it out.
        //neighbours.sort(function(a, b){
        //    return h(a, end) - h(b, end);
        //});


        /*jshint -W084 *///Disable warning: Expected a conditional expression and instead saw an assignment
        for (k = 0, min = Infinity; neighbour = neighbours[k]; ++k) {
        /*jshint +W084 *///Enable warning: Expected a conditional expression and instead saw an assignment
            if (this.trackRecursion) {
                // Retain a copy for visualisation. Due to recursion, this
                // node may be part of other paths too.
                neighbour.retainCount = neighbour.retainCount + 1 || 1;

                if(neighbour.tested !== true) {
                    neighbour.tested = true;
                }
            }

            t = search(neighbour, g + cost(node, neighbour), cutoff, route, depth + 1);

            if (t instanceof Node) {
                route[depth] = [node.x, node.y];

                // For a typical A* linked list, this would work:
                // neighbour.parent = node;
                return t;
            }

            // Decrement count, then determine whether it's actually closed.
            if (this.trackRecursion && (--neighbour.retainCount) === 0) {
                neighbour.tested = false;
            }

            if (t < min) {
                min = t;
            }
        }

        return min;

    }.bind(this);

    // Node instance lookups:
    var start = grid.getNodeAt(startX, startY);
    var end   = grid.getNodeAt(endX, endY);

    // Initial search depth, given the typical heuristic contraints,
    // there should be no cheaper route possible.
    var cutOff = h(start, end);

    var j, route, t;

    // With an overflow protection.
    for (j = 0; true; ++j) {

        route = [];

        // Search till cut-off depth:
        t = search(start, 0, cutOff, route, 0);

        // Route not possible, or not found in time limit.
        if (t === Infinity) {
            return [];
        }

        // If t is a node, it's also the end node. Route is now
        // populated with a valid path to the end node.
        if (t instanceof Node) {
            return route;
        }

        // Try again, this time with a deeper cut-off. The t score
        // is the closest we got to the end node.
        cutOff = t;
    }

    // This _should_ never to be reached.
    return [];
};

module.exports = IDAStarFinder;

},{"../core/DiagonalMovement":3,"../core/Heuristic":5,"../core/Node":6,"../core/Util":7}],18:[function(_dereq_,module,exports){
/**
 * @author imor / https://github.com/imor
 */
var JumpPointFinderBase = _dereq_('./JumpPointFinderBase');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Path finder using the Jump Point Search algorithm which always moves
 * diagonally irrespective of the number of obstacles.
 */
function JPFAlwaysMoveDiagonally(opt) {
    JumpPointFinderBase.call(this, opt);
}

JPFAlwaysMoveDiagonally.prototype = new JumpPointFinderBase();
JPFAlwaysMoveDiagonally.prototype.constructor = JPFAlwaysMoveDiagonally;

/**
 * Search recursively in the direction (parent -> child), stopping only when a
 * jump point is found.
 * @protected
 * @return {Array<Array<number>>} The x, y coordinate of the jump point
 *     found, or null if not found
 */
JPFAlwaysMoveDiagonally.prototype._jump = function(x, y, px, py) {
    var grid = this.grid,
        dx = x - px, dy = y - py;

    if (!grid.isWalkableAt(x, y)) {
        return null;
    }

    if(this.trackJumpRecursion === true) {
        grid.getNodeAt(x, y).tested = true;
    }

    if (grid.getNodeAt(x, y) === this.endNode) {
        return [x, y];
    }

    // check for forced neighbors
    // along the diagonal
    if (dx !== 0 && dy !== 0) {
        if ((grid.isWalkableAt(x - dx, y + dy) && !grid.isWalkableAt(x - dx, y)) ||
            (grid.isWalkableAt(x + dx, y - dy) && !grid.isWalkableAt(x, y - dy))) {
            return [x, y];
        }
        // when moving diagonally, must check for vertical/horizontal jump points
        if (this._jump(x + dx, y, x, y) || this._jump(x, y + dy, x, y)) {
            return [x, y];
        }
    }
    // horizontally/vertically
    else {
        if( dx !== 0 ) { // moving along x
            if((grid.isWalkableAt(x + dx, y + 1) && !grid.isWalkableAt(x, y + 1)) ||
               (grid.isWalkableAt(x + dx, y - 1) && !grid.isWalkableAt(x, y - 1))) {
                return [x, y];
            }
        }
        else {
            if((grid.isWalkableAt(x + 1, y + dy) && !grid.isWalkableAt(x + 1, y)) ||
               (grid.isWalkableAt(x - 1, y + dy) && !grid.isWalkableAt(x - 1, y))) {
                return [x, y];
            }
        }
    }

    return this._jump(x + dx, y + dy, x, y);
};

/**
 * Find the neighbors for the given node. If the node has a parent,
 * prune the neighbors based on the jump point search algorithm, otherwise
 * return all available neighbors.
 * @return {Array<Array<number>>} The neighbors found.
 */
JPFAlwaysMoveDiagonally.prototype._findNeighbors = function(node) {
    var parent = node.parent,
        x = node.x, y = node.y,
        grid = this.grid,
        px, py, nx, ny, dx, dy,
        neighbors = [], neighborNodes, neighborNode, i, l;

    // directed pruning: can ignore most neighbors, unless forced.
    if (parent) {
        px = parent.x;
        py = parent.y;
        // get the normalized direction of travel
        dx = (x - px) / Math.max(Math.abs(x - px), 1);
        dy = (y - py) / Math.max(Math.abs(y - py), 1);

        // search diagonally
        if (dx !== 0 && dy !== 0) {
            if (grid.isWalkableAt(x, y + dy)) {
                neighbors.push([x, y + dy]);
            }
            if (grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y]);
            }
            if (grid.isWalkableAt(x + dx, y + dy)) {
                neighbors.push([x + dx, y + dy]);
            }
            if (!grid.isWalkableAt(x - dx, y)) {
                neighbors.push([x - dx, y + dy]);
            }
            if (!grid.isWalkableAt(x, y - dy)) {
                neighbors.push([x + dx, y - dy]);
            }
        }
        // search horizontally/vertically
        else {
            if(dx === 0) {
                if (grid.isWalkableAt(x, y + dy)) {
                    neighbors.push([x, y + dy]);
                }
                if (!grid.isWalkableAt(x + 1, y)) {
                    neighbors.push([x + 1, y + dy]);
                }
                if (!grid.isWalkableAt(x - 1, y)) {
                    neighbors.push([x - 1, y + dy]);
                }
            }
            else {
                if (grid.isWalkableAt(x + dx, y)) {
                    neighbors.push([x + dx, y]);
                }
                if (!grid.isWalkableAt(x, y + 1)) {
                    neighbors.push([x + dx, y + 1]);
                }
                if (!grid.isWalkableAt(x, y - 1)) {
                    neighbors.push([x + dx, y - 1]);
                }
            }
        }
    }
    // return all neighbors
    else {
        neighborNodes = grid.getNeighbors(node, DiagonalMovement.Always);
        for (i = 0, l = neighborNodes.length; i < l; ++i) {
            neighborNode = neighborNodes[i];
            neighbors.push([neighborNode.x, neighborNode.y]);
        }
    }

    return neighbors;
};

module.exports = JPFAlwaysMoveDiagonally;

},{"../core/DiagonalMovement":3,"./JumpPointFinderBase":23}],19:[function(_dereq_,module,exports){
/**
 * @author imor / https://github.com/imor
 */
var JumpPointFinderBase = _dereq_('./JumpPointFinderBase');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Path finder using the Jump Point Search algorithm which moves
 * diagonally only when there is at most one obstacle.
 */
function JPFMoveDiagonallyIfAtMostOneObstacle(opt) {
    JumpPointFinderBase.call(this, opt);
}

JPFMoveDiagonallyIfAtMostOneObstacle.prototype = new JumpPointFinderBase();
JPFMoveDiagonallyIfAtMostOneObstacle.prototype.constructor = JPFMoveDiagonallyIfAtMostOneObstacle;

/**
 * Search recursively in the direction (parent -> child), stopping only when a
 * jump point is found.
 * @protected
 * @return {Array<Array<number>>} The x, y coordinate of the jump point
 *     found, or null if not found
 */
JPFMoveDiagonallyIfAtMostOneObstacle.prototype._jump = function(x, y, px, py) {
    var grid = this.grid,
        dx = x - px, dy = y - py;

    if (!grid.isWalkableAt(x, y)) {
        return null;
    }

    if(this.trackJumpRecursion === true) {
        grid.getNodeAt(x, y).tested = true;
    }

    if (grid.getNodeAt(x, y) === this.endNode) {
        return [x, y];
    }

    // check for forced neighbors
    // along the diagonal
    if (dx !== 0 && dy !== 0) {
        if ((grid.isWalkableAt(x - dx, y + dy) && !grid.isWalkableAt(x - dx, y)) ||
            (grid.isWalkableAt(x + dx, y - dy) && !grid.isWalkableAt(x, y - dy))) {
            return [x, y];
        }
        // when moving diagonally, must check for vertical/horizontal jump points
        if (this._jump(x + dx, y, x, y) || this._jump(x, y + dy, x, y)) {
            return [x, y];
        }
    }
    // horizontally/vertically
    else {
        if( dx !== 0 ) { // moving along x
            if((grid.isWalkableAt(x + dx, y + 1) && !grid.isWalkableAt(x, y + 1)) ||
               (grid.isWalkableAt(x + dx, y - 1) && !grid.isWalkableAt(x, y - 1))) {
                return [x, y];
            }
        }
        else {
            if((grid.isWalkableAt(x + 1, y + dy) && !grid.isWalkableAt(x + 1, y)) ||
               (grid.isWalkableAt(x - 1, y + dy) && !grid.isWalkableAt(x - 1, y))) {
                return [x, y];
            }
        }
    }

    // moving diagonally, must make sure one of the vertical/horizontal
    // neighbors is open to allow the path
    if (grid.isWalkableAt(x + dx, y) || grid.isWalkableAt(x, y + dy)) {
        return this._jump(x + dx, y + dy, x, y);
    } else {
        return null;
    }
};

/**
 * Find the neighbors for the given node. If the node has a parent,
 * prune the neighbors based on the jump point search algorithm, otherwise
 * return all available neighbors.
 * @return {Array<Array<number>>} The neighbors found.
 */
JPFMoveDiagonallyIfAtMostOneObstacle.prototype._findNeighbors = function(node) {
    var parent = node.parent,
        x = node.x, y = node.y,
        grid = this.grid,
        px, py, nx, ny, dx, dy,
        neighbors = [], neighborNodes, neighborNode, i, l;

    // directed pruning: can ignore most neighbors, unless forced.
    if (parent) {
        px = parent.x;
        py = parent.y;
        // get the normalized direction of travel
        dx = (x - px) / Math.max(Math.abs(x - px), 1);
        dy = (y - py) / Math.max(Math.abs(y - py), 1);

        // search diagonally
        if (dx !== 0 && dy !== 0) {
            if (grid.isWalkableAt(x, y + dy)) {
                neighbors.push([x, y + dy]);
            }
            if (grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y]);
            }
            if (grid.isWalkableAt(x, y + dy) || grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y + dy]);
            }
            if (!grid.isWalkableAt(x - dx, y) && grid.isWalkableAt(x, y + dy)) {
                neighbors.push([x - dx, y + dy]);
            }
            if (!grid.isWalkableAt(x, y - dy) && grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y - dy]);
            }
        }
        // search horizontally/vertically
        else {
            if(dx === 0) {
                if (grid.isWalkableAt(x, y + dy)) {
                    neighbors.push([x, y + dy]);
                    if (!grid.isWalkableAt(x + 1, y)) {
                        neighbors.push([x + 1, y + dy]);
                    }
                    if (!grid.isWalkableAt(x - 1, y)) {
                        neighbors.push([x - 1, y + dy]);
                    }
                }
            }
            else {
                if (grid.isWalkableAt(x + dx, y)) {
                    neighbors.push([x + dx, y]);
                    if (!grid.isWalkableAt(x, y + 1)) {
                        neighbors.push([x + dx, y + 1]);
                    }
                    if (!grid.isWalkableAt(x, y - 1)) {
                        neighbors.push([x + dx, y - 1]);
                    }
                }
            }
        }
    }
    // return all neighbors
    else {
        neighborNodes = grid.getNeighbors(node, DiagonalMovement.IfAtMostOneObstacle);
        for (i = 0, l = neighborNodes.length; i < l; ++i) {
            neighborNode = neighborNodes[i];
            neighbors.push([neighborNode.x, neighborNode.y]);
        }
    }

    return neighbors;
};

module.exports = JPFMoveDiagonallyIfAtMostOneObstacle;

},{"../core/DiagonalMovement":3,"./JumpPointFinderBase":23}],20:[function(_dereq_,module,exports){
/**
 * @author imor / https://github.com/imor
 */
var JumpPointFinderBase = _dereq_('./JumpPointFinderBase');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Path finder using the Jump Point Search algorithm which moves
 * diagonally only when there are no obstacles.
 */
function JPFMoveDiagonallyIfNoObstacles(opt) {
    JumpPointFinderBase.call(this, opt);
}

JPFMoveDiagonallyIfNoObstacles.prototype = new JumpPointFinderBase();
JPFMoveDiagonallyIfNoObstacles.prototype.constructor = JPFMoveDiagonallyIfNoObstacles;

/**
 * Search recursively in the direction (parent -> child), stopping only when a
 * jump point is found.
 * @protected
 * @return {Array<Array<number>>} The x, y coordinate of the jump point
 *     found, or null if not found
 */
JPFMoveDiagonallyIfNoObstacles.prototype._jump = function(x, y, px, py) {
    var grid = this.grid,
        dx = x - px, dy = y - py;

    if (!grid.isWalkableAt(x, y)) {
        return null;
    }

    if(this.trackJumpRecursion === true) {
        grid.getNodeAt(x, y).tested = true;
    }

    if (grid.getNodeAt(x, y) === this.endNode) {
        return [x, y];
    }

    // check for forced neighbors
    // along the diagonal
    if (dx !== 0 && dy !== 0) {
        // if ((grid.isWalkableAt(x - dx, y + dy) && !grid.isWalkableAt(x - dx, y)) ||
            // (grid.isWalkableAt(x + dx, y - dy) && !grid.isWalkableAt(x, y - dy))) {
            // return [x, y];
        // }
        // when moving diagonally, must check for vertical/horizontal jump points
        if (this._jump(x + dx, y, x, y) || this._jump(x, y + dy, x, y)) {
            return [x, y];
        }
    }
    // horizontally/vertically
    else {
        if (dx !== 0) {
            if ((grid.isWalkableAt(x, y - 1) && !grid.isWalkableAt(x - dx, y - 1)) ||
                (grid.isWalkableAt(x, y + 1) && !grid.isWalkableAt(x - dx, y + 1))) {
                return [x, y];
            }
        }
        else if (dy !== 0) {
            if ((grid.isWalkableAt(x - 1, y) && !grid.isWalkableAt(x - 1, y - dy)) ||
                (grid.isWalkableAt(x + 1, y) && !grid.isWalkableAt(x + 1, y - dy))) {
                return [x, y];
            }
            // When moving vertically, must check for horizontal jump points
            // if (this._jump(x + 1, y, x, y) || this._jump(x - 1, y, x, y)) {
                // return [x, y];
            // }
        }
    }

    // moving diagonally, must make sure one of the vertical/horizontal
    // neighbors is open to allow the path
    if (grid.isWalkableAt(x + dx, y) && grid.isWalkableAt(x, y + dy)) {
        return this._jump(x + dx, y + dy, x, y);
    } else {
        return null;
    }
};

/**
 * Find the neighbors for the given node. If the node has a parent,
 * prune the neighbors based on the jump point search algorithm, otherwise
 * return all available neighbors.
 * @return {Array<Array<number>>} The neighbors found.
 */
JPFMoveDiagonallyIfNoObstacles.prototype._findNeighbors = function(node) {
    var parent = node.parent,
        x = node.x, y = node.y,
        grid = this.grid,
        px, py, nx, ny, dx, dy,
        neighbors = [], neighborNodes, neighborNode, i, l;

    // directed pruning: can ignore most neighbors, unless forced.
    if (parent) {
        px = parent.x;
        py = parent.y;
        // get the normalized direction of travel
        dx = (x - px) / Math.max(Math.abs(x - px), 1);
        dy = (y - py) / Math.max(Math.abs(y - py), 1);

        // search diagonally
        if (dx !== 0 && dy !== 0) {
            if (grid.isWalkableAt(x, y + dy)) {
                neighbors.push([x, y + dy]);
            }
            if (grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y]);
            }
            if (grid.isWalkableAt(x, y + dy) && grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y + dy]);
            }
        }
        // search horizontally/vertically
        else {
            var isNextWalkable;
            if (dx !== 0) {
                isNextWalkable = grid.isWalkableAt(x + dx, y);
                var isTopWalkable = grid.isWalkableAt(x, y + 1);
                var isBottomWalkable = grid.isWalkableAt(x, y - 1);

                if (isNextWalkable) {
                    neighbors.push([x + dx, y]);
                    if (isTopWalkable) {
                        neighbors.push([x + dx, y + 1]);
                    }
                    if (isBottomWalkable) {
                        neighbors.push([x + dx, y - 1]);
                    }
                }
                if (isTopWalkable) {
                    neighbors.push([x, y + 1]);
                }
                if (isBottomWalkable) {
                    neighbors.push([x, y - 1]);
                }
            }
            else if (dy !== 0) {
                isNextWalkable = grid.isWalkableAt(x, y + dy);
                var isRightWalkable = grid.isWalkableAt(x + 1, y);
                var isLeftWalkable = grid.isWalkableAt(x - 1, y);

                if (isNextWalkable) {
                    neighbors.push([x, y + dy]);
                    if (isRightWalkable) {
                        neighbors.push([x + 1, y + dy]);
                    }
                    if (isLeftWalkable) {
                        neighbors.push([x - 1, y + dy]);
                    }
                }
                if (isRightWalkable) {
                    neighbors.push([x + 1, y]);
                }
                if (isLeftWalkable) {
                    neighbors.push([x - 1, y]);
                }
            }
        }
    }
    // return all neighbors
    else {
        neighborNodes = grid.getNeighbors(node, DiagonalMovement.OnlyWhenNoObstacles);
        for (i = 0, l = neighborNodes.length; i < l; ++i) {
            neighborNode = neighborNodes[i];
            neighbors.push([neighborNode.x, neighborNode.y]);
        }
    }

    return neighbors;
};

module.exports = JPFMoveDiagonallyIfNoObstacles;

},{"../core/DiagonalMovement":3,"./JumpPointFinderBase":23}],21:[function(_dereq_,module,exports){
/**
 * @author imor / https://github.com/imor
 */
var JumpPointFinderBase = _dereq_('./JumpPointFinderBase');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Path finder using the Jump Point Search algorithm allowing only horizontal
 * or vertical movements.
 */
function JPFNeverMoveDiagonally(opt) {
    JumpPointFinderBase.call(this, opt);
}

JPFNeverMoveDiagonally.prototype = new JumpPointFinderBase();
JPFNeverMoveDiagonally.prototype.constructor = JPFNeverMoveDiagonally;

/**
 * Search recursively in the direction (parent -> child), stopping only when a
 * jump point is found.
 * @protected
 * @return {Array<Array<number>>} The x, y coordinate of the jump point
 *     found, or null if not found
 */
JPFNeverMoveDiagonally.prototype._jump = function(x, y, px, py) {
    var grid = this.grid,
        dx = x - px, dy = y - py;

    if (!grid.isWalkableAt(x, y)) {
        return null;
    }

    if(this.trackJumpRecursion === true) {
        grid.getNodeAt(x, y).tested = true;
    }

    if (grid.getNodeAt(x, y) === this.endNode) {
        return [x, y];
    }

    if (dx !== 0) {
        if ((grid.isWalkableAt(x, y - 1) && !grid.isWalkableAt(x - dx, y - 1)) ||
            (grid.isWalkableAt(x, y + 1) && !grid.isWalkableAt(x - dx, y + 1))) {
            return [x, y];
        }
    }
    else if (dy !== 0) {
        if ((grid.isWalkableAt(x - 1, y) && !grid.isWalkableAt(x - 1, y - dy)) ||
            (grid.isWalkableAt(x + 1, y) && !grid.isWalkableAt(x + 1, y - dy))) {
            return [x, y];
        }
        //When moving vertically, must check for horizontal jump points
        if (this._jump(x + 1, y, x, y) || this._jump(x - 1, y, x, y)) {
            return [x, y];
        }
    }
    else {
        throw new Error("Only horizontal and vertical movements are allowed");
    }

    return this._jump(x + dx, y + dy, x, y);
};

/**
 * Find the neighbors for the given node. If the node has a parent,
 * prune the neighbors based on the jump point search algorithm, otherwise
 * return all available neighbors.
 * @return {Array<Array<number>>} The neighbors found.
 */
JPFNeverMoveDiagonally.prototype._findNeighbors = function(node) {
    var parent = node.parent,
        x = node.x, y = node.y,
        grid = this.grid,
        px, py, nx, ny, dx, dy,
        neighbors = [], neighborNodes, neighborNode, i, l;

    // directed pruning: can ignore most neighbors, unless forced.
    if (parent) {
        px = parent.x;
        py = parent.y;
        // get the normalized direction of travel
        dx = (x - px) / Math.max(Math.abs(x - px), 1);
        dy = (y - py) / Math.max(Math.abs(y - py), 1);

        if (dx !== 0) {
            if (grid.isWalkableAt(x, y - 1)) {
                neighbors.push([x, y - 1]);
            }
            if (grid.isWalkableAt(x, y + 1)) {
                neighbors.push([x, y + 1]);
            }
            if (grid.isWalkableAt(x + dx, y)) {
                neighbors.push([x + dx, y]);
            }
        }
        else if (dy !== 0) {
            if (grid.isWalkableAt(x - 1, y)) {
                neighbors.push([x - 1, y]);
            }
            if (grid.isWalkableAt(x + 1, y)) {
                neighbors.push([x + 1, y]);
            }
            if (grid.isWalkableAt(x, y + dy)) {
                neighbors.push([x, y + dy]);
            }
        }
    }
    // return all neighbors
    else {
        neighborNodes = grid.getNeighbors(node, DiagonalMovement.Never);
        for (i = 0, l = neighborNodes.length; i < l; ++i) {
            neighborNode = neighborNodes[i];
            neighbors.push([neighborNode.x, neighborNode.y]);
        }
    }

    return neighbors;
};

module.exports = JPFNeverMoveDiagonally;

},{"../core/DiagonalMovement":3,"./JumpPointFinderBase":23}],22:[function(_dereq_,module,exports){
/**
 * @author aniero / https://github.com/aniero
 */
var DiagonalMovement = _dereq_('../core/DiagonalMovement');
var JPFNeverMoveDiagonally = _dereq_('./JPFNeverMoveDiagonally');
var JPFAlwaysMoveDiagonally = _dereq_('./JPFAlwaysMoveDiagonally');
var JPFMoveDiagonallyIfNoObstacles = _dereq_('./JPFMoveDiagonallyIfNoObstacles');
var JPFMoveDiagonallyIfAtMostOneObstacle = _dereq_('./JPFMoveDiagonallyIfAtMostOneObstacle');

/**
 * Path finder using the Jump Point Search algorithm
 * @param {Object} opt
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 * @param {DiagonalMovement} opt.diagonalMovement Condition under which diagonal
 *      movement will be allowed.
 */
function JumpPointFinder(opt) {
    opt = opt || {};
    if (opt.diagonalMovement === DiagonalMovement.Never) {
        return new JPFNeverMoveDiagonally(opt);
    } else if (opt.diagonalMovement === DiagonalMovement.Always) {
        return new JPFAlwaysMoveDiagonally(opt);
    } else if (opt.diagonalMovement === DiagonalMovement.OnlyWhenNoObstacles) {
        return new JPFMoveDiagonallyIfNoObstacles(opt);
    } else {
        return new JPFMoveDiagonallyIfAtMostOneObstacle(opt);
    }
}

module.exports = JumpPointFinder;

},{"../core/DiagonalMovement":3,"./JPFAlwaysMoveDiagonally":18,"./JPFMoveDiagonallyIfAtMostOneObstacle":19,"./JPFMoveDiagonallyIfNoObstacles":20,"./JPFNeverMoveDiagonally":21}],23:[function(_dereq_,module,exports){
/**
 * @author imor / https://github.com/imor
 */
var Heap       = _dereq_('heap');
var Util       = _dereq_('../core/Util');
var Heuristic  = _dereq_('../core/Heuristic');
var DiagonalMovement = _dereq_('../core/DiagonalMovement');

/**
 * Base class for the Jump Point Search algorithm
 * @param {object} opt
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
function JumpPointFinderBase(opt) {
    opt = opt || {};
    this.heuristic = opt.heuristic || Heuristic.manhattan;
    this.trackJumpRecursion = opt.trackJumpRecursion || false;
}

/**
 * Find and return the path.
 * @return {Array<Array<number>>} The path, including both start and
 *     end positions.
 */
JumpPointFinderBase.prototype.findPath = function(startX, startY, endX, endY, grid) {
    var openList = this.openList = new Heap(function(nodeA, nodeB) {
            return nodeA.f - nodeB.f;
        }),
        startNode = this.startNode = grid.getNodeAt(startX, startY),
        endNode = this.endNode = grid.getNodeAt(endX, endY), node;

    this.grid = grid;


    startNode.g = 0;
    startNode.f = 0;

    // push the start node into the open list
    openList.push(startNode);
    startNode.opened = true;

    // while the open list is not empty
    while (!openList.empty()) {
        // pop the position of node which has the minimum
        node = openList.pop();
        node.closed = true;

        if (node === endNode) {
            return Util.expandPath(Util.backtrace(endNode));
        }

        this._identifySuccessors(node);
    }

    // fail to find the path
    return [];
};

/**
 * Identify successors for the given node. Runs a jump point search in the
 * direction of each available neighbor, adding any points found to the open
 * list.
 * @protected
 */
JumpPointFinderBase.prototype._identifySuccessors = function(node) {
    var grid = this.grid,
        heuristic = this.heuristic,
        openList = this.openList,
        endX = this.endNode.x,
        endY = this.endNode.y,
        neighbors, neighbor,
        jumpPoint, i, l,
        x = node.x, y = node.y,
        jx, jy, dx, dy, d, ng, jumpNode,
        abs = Math.abs, max = Math.max;

    neighbors = this._findNeighbors(node);
    for(i = 0, l = neighbors.length; i < l; ++i) {
        neighbor = neighbors[i];
        jumpPoint = this._jump(neighbor[0], neighbor[1], x, y);
        if (jumpPoint) {

            jx = jumpPoint[0];
            jy = jumpPoint[1];
            jumpNode = grid.getNodeAt(jx, jy);

            if (jumpNode.closed) {
                continue;
            }

            // include distance, as parent may not be immediately adjacent:
            d = Heuristic.octile(abs(jx - x), abs(jy - y));
            ng = node.g + d;

            if (!jumpNode.opened || ng < jumpNode.g) {
                jumpNode.g = ng;
                jumpNode.h = jumpNode.h || heuristic(abs(jx - endX), abs(jy - endY));
                jumpNode.f = jumpNode.g + jumpNode.h;
                jumpNode.parent = node;

                if (!jumpNode.opened) {
                    openList.push(jumpNode);
                    jumpNode.opened = true;
                } else {
                    openList.updateItem(jumpNode);
                }
            }
        }
    }
};

module.exports = JumpPointFinderBase;

},{"../core/DiagonalMovement":3,"../core/Heuristic":5,"../core/Util":7,"heap":1}]},{},[8])
(8)
});`

# integrate into torch
TorchModule this[ "PF" ], "PF"

# dereferece global
this[ "PF" ] = temp

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

class SizeManager
    width: 0
    height: 0
    scale: null

    constructor: (@sprite) ->
        rect = @sprite.rectangle
        @width = rect.width
        @height = rect.height
        @scale = {width: 1, height: 1}

    Update: ->
        rect = @sprite.rectangle

        if @sprite.torch_shape
            rect.width = @sprite.width
            rect.height = @sprite.height

    Set: (width, height) ->
        @width = @sprite.rectangle.width = width * @scale.width
        @height = @sprite.rectangle.height = height * @scale.height

    Scale: (widthScale, heightScale) ->
        rect = @sprite.rectangle

        @scale.width = widthScale
        @scale.height = heightScale

        rect.width = @width * @scale.width
        rect.height = @height * @scale.height

class EventManager
    mouseOver: false
    clickTrigger: false
    clickAwayTrigger: false
    draw: true
    wasClicked: false

    constructor: (@sprite) ->
        @game = @sprite.game

    Update: ->
        if not @game.Mouse.GetRectangle().Intersects(@sprite.rectangle) and @mouseOver
            @mouseOver = false
            @sprite.Emit("MouseLeave", new Torch.Event(@game, {sprite: @sprite}))

        if @game.Mouse.GetRectangle().Intersects(@sprite.rectangle)
            if not @mouseOver
                @sprite.Emit("MouseOver", new Torch.Event(@game, {sprite: @sprite}))
            @mouseOver = true

        else if @sprite.fixed
            mouseRec = @game.Mouse.GetRectangle()
            reComputedMouseRec = new Rectangle(mouseRec.x, mouseRec.y, mouseRec.width, mouseRec.height)
            reComputedMouseRec.x += @game.Camera.position.x
            reComputedMouseRec.y += @game.Camera.position.y
            if reComputedMouseRec.Intersects(@sprite.rectangle)
                @mouseOver = true
            else
                @mouseOver = false
        else
            @mouseOver = false

        if @mouseOver and @game.Mouse.down and not @clickTrigger
            @clickTrigger = true
            @sprite.Emit "MouseDown", new Torch.Event( @game, sprite: @sprite )

        if @clickTrigger and not @game.Mouse.down and @mouseOver
            @wasClicked = true

            @sprite.Emit "MouseUp", new Torch.Event( @game, {sprite: @sprite} )
            @sprite.Emit "Click", new Torch.Event( @game, {sprite: @sprite} )

            @clickTrigger = false

        if @clickTrigger and not @game.Mouse.down and not @mouseOver
            @clickTrigger = false

        if not @game.Mouse.down and not @mouseOver and @clickAwayTrigger
            @sprite.Emit("ClickAway", new Torch.Event(@game, {sprite: @sprite}))
            @wasClicked = false
            @clickAwayTrigger = false

        else if @clickTrigger and not @game.Mouse.down and @mouseOver
            @clickAwayTrigger = false

        else if @game.Mouse.down and not @mouseOver
            @clickAwayTrigger = true

class EffectManager
    tint: null
    mask: null
    effects: null

    constructor: (@sprite) ->
        @effects = []
        @tint = new EffectComponent.Tint()
        @mask = new EffectComponent.Mask()

    Update: ->
        @effects = for effect in @effects
            effect.Update()

            effect if not effect.trash

    Blink: (interval = 300)->
        t = @sprite.game.Tweens.Tween(@sprite, interval, Torch.Easing.Smooth).To( opacity: 0 ).Cycle()
        return t

    Flash: (color = "red", time = 100) ->
        @tint.color = color
        t = @sprite.game.Tweens.Tween( @tint, time, Torch.Easing.Smooth ).From(opacity: 0).To( opacity: 1 )
        t.On "Finish", =>
            t2 = @sprite.game.Tweens.Tween( @tint, time, Torch.Easing.Smooth ).To( opacity: 0 )
            t2.On "Finish", =>
                @tint.color = null
                @tint.opacity = 0.5

    Crumple: (ratio, time) ->

        targetHeight = @sprite.rectangle.height * ratio

        @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( height: targetHeight )

    Stretch: (ratio, time) ->
        targetWidth = @sprite.rectangle.width * ratio

        @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( width: targetWidth )

    Squirt: (point, time) ->
        origWidth = @sprite.rectangle.width
        origHeight = @sprite.rectangle.height

        widthDiff = Math.abs (point.x - @sprite.position.x)
        heightDiff = Math.abs (point.y - @sprite.position.y)

        if widthDiff > 0
            @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( width: widthDiff )

        if heightDiff > 0
            @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( height: heightDiff )

        tween = @sprite.game.Tweens.Tween( @sprite.position, time, Torch.Easing.Smooth ).To( x: point.x, y: point.y )

        tween.On "Finish", =>
            @sprite.game.Tweens.Tween( @sprite.rectangle, time, Torch.Easing.Smooth ).To( width: origWidth, height: origHeight )

    Trail: () ->
        @effects.push( new TrailEffect(@sprite) )

# a bunch of little effects containers
EffectComponent = {}

class EffectComponent.Tint
    _color: null
    _opacity: 0.5

    @property 'color',
        get: -> return @_color
        set: (value) -> @_color = value

    @property 'opacity',
        get: -> return @_opacity
        set: (value) -> @_opacity = value

class EffectComponent.Mask
    _texture: null
    _in: false
    _out: false
    # destination-in, destination-out
    @property 'texture',
        get: -> return @_texture
        set: (value) -> @_texture = value

    @property 'in',
        get: -> return @_in
        set: (value) -> @_in = value

    @property 'out',
        get: -> return @_out
        set: (value) -> @_out = value

# effects
class TrailEffect
    fadeTime: 200
    constructor: (@sprite) ->

    Update: ->
        t = new Sprite(@sprite.game, @sprite.position.x, @sprite.position.y)
        t.Bind.Texture(@sprite.texture.image)
        t.Size.Scale(1,1)
        t.drawIndex = @sprite.drawIndex - 1
        t.rotation = @sprite.rotation

        @sprite.game.Tweens.Tween( t, @fadeTime, Torch.Easing.Smooth )
        .From( opacity: 0.2 )
        .To( opacity: 0 ).On "Finish", =>
            t.Trash()

class StateMachineManager
    constructor: (@sprite) ->
        @stateMachines = {}

    CreateStateMachine: (name) ->
        @stateMachines[name] = new StateMachine(@sprite)
        return @stateMachines[name]

    GetStateMachine: (name) ->
        return @stateMachines[name]

    Update: ->
        for key,sm of @stateMachines
            sm.Update()

###
    @class GridManager

    Manages the relative position of sprites
###
class GridManager
    parent: null
    children: null

    centered: false
    centerVertical: false

    alignLeft: false
    alignRight: false
    alignTop: false
    alignBottom: false

    margin: null

    constructor: (@sprite) ->
        @position = new Point(0,0)
        @children = []
        @margin =
            left: 0
            top: 0

    Align: (positionTags...) ->
        for tag in positionTags
            switch tag
                when "left"
                    @alignLeft = true
                when "right"
                    @alignRight = true
                when "top"
                    @alignTop = true
                when "bottom"
                    @alignBottom = true
        return @

    Center: (turnOn = true)->
        @centered = turnOn
        return @

    CenterVertical: (turnOn = true)->
        @centerVertical = turnOn
        return @

    Margin: (left = 0, top = 0) ->
        @margin.left = left
        @margin.top = top
        return @

    Append: (sprite) ->
        sprite.Grid.parent = @sprite
        sprite.drawIndex = @sprite.drawIndex + 1
        sprite.fixed = @sprite.fixed

        return @

    Parent: ->
        return @parent

    Children: (matcher) ->
        return @children if not matcher

        children = []

        for child in @children
            matching = true
            for key,value of matcher
                if not child[key] is value
                    matching = false

            children.append(child) if matching

        return children

    Ancestors: (matcher) ->
        return null if not @parent
        ancestors = []

        ancestor = @parent

        while ancestor.Parent() isnt null
            if not matcher
                ancestors.push(ancestor)
            else
                matched = true
                for key,value of matcher
                    if ancestor[key] isnt value
                        matched = false
                ancestors.push(ancestor) if matched

            ancestor = ancestor.Parent()

    ApplyCentering: (point) ->
        if @centered
            point.x = (point.x + @parent.rectangle.width / 2) - (@sprite.rectangle.width / 2)

        if @centerVertical
            point.y = (point.y + @parent.rectangle.height / 2) - (@sprite.rectangle.height / 2)

        return point

    ApplyAlignment: (point) ->
        if @alignLeft
            point.x = 0
        if @alignRight
            point.x = point.x + (@parent.rectangle.width - @sprite.rectangle.width)
        if @alignTop
            point.y = 0
        if @alignBottom
            point.y = point.y + (@parent.rectangle.height - @sprite.rectangle.height)

        return point

    ResolveAbosolutePosition: ->
        if @parent is null
            return @sprite.position

        basePoint = @parent.position.Clone()

        basePoint = @ApplyCentering(basePoint)
        basePoint = @ApplyAlignment(basePoint)
        basePoint.x += @position.x
        basePoint.y += @position.y

        basePoint.x += @margin.left
        basePoint.y += @margin.top

        return basePoint;

    Update: ->
        @sprite.position = @ResolveAbosolutePosition()
        if @parent isnt null
            @sprite.drawIndex = @parent.drawIndex + 1
            @sprite.fixed = @parent.fixed

class Animation extends Trashable
    @MixIn Trashable
    @MixIn EventDispatcher

    loop: false
    stopped: false
    intervalTime: 0
    stepTime: 0
    constructor: ->
        @InitEventDispatch()

    Loop: ->
        @loop = true
        return @


class AnimationManager
    animations: null
    constructor: (@sprite) ->
        @animations = []

    Update: ->
        cleanedAnims = []
        for anim in @animations
            anim.Update()
            cleanedAnims.push(anim) if not anim.trash
        @animations = cleanedAnims

    SpriteSheet: (width, height, numberOfFrames, config = {step: 200}) ->
        anim = new SpriteSheetAnimation(@sprite, width, height, numberOfFrames, config.step)
        @animations.push( anim )
        return anim

    AtlasFrame: (atlasId, textureId, frames, config = {step: 200}) ->
        anim = new AtlasFrameAnimation(@sprite, atlasId, textureId, frames, config.step)
        @animations.push( anim )
        return anim

class SpriteSheetAnimation extends Animation
    index: -1
    clipX: 0
    clipY: 0
    game: null
    clipWidth: null
    clipHeight: null
    numberOfFrames: null
    stepTime: null

    constructor: (@sprite, @clipWidth, @clipHeight, @numberOfFrames, @stepTime) ->
        super()
        @loop = true
        @game = @sprite.game
        @Reset()

    Update: ->
        return if @stopped
        @intervalTime += @game.Loop.updateDelta

        if @intervalTime >= @stepTime
            @AdvanceFrame()

    AdvanceFrame: ->
        @intervalTime = 0
        @index += 1

        @sprite.texture.drawParams.clipX = @index * @clipWidth

        if @index >= @numberOfFrames - 1

            if @loop
                @index = -1
            else
                @Trash()

    Stop: ->
        @stopped = true

    Start: ->
        @stopped = false

    Index: (index) ->
        @index = index - 1
        @sprite.texture.drawParams.clipX = ( @index + 1) * @clipWidth

    Reset: ->
        @intervalTime = 0
        @index = -1

        @sprite.texture.drawParams.clipX = 0
        @sprite.texture.drawParams.clipY = 0
        @sprite.texture.drawParams.clipWidth = @clipWidth
        @sprite.texture.drawParams.clipHeight = @clipHeight
        @sprite.Size.width = @clipWidth
        @sprite.Size.height = @clipHeight

    SyncFrame: ->
        @sprite.texture.drawParams.clipX = 0
        @sprite.texture.drawParams.clipY = 0
        @sprite.texture.drawParams.clipWidth = @clipWidth
        @sprite.texture.drawParams.clipHeight = @clipHeight
        @sprite.Size.width = @clipWidth
        @sprite.Size.height = @clipHeight

class AtlasFrameAnimation extends Animation
    index: 0
    constructor: (@sprite, @atlasId, @textureId, @frames, @stepTime) ->
        super()
        @game = @sprite.game
        @numberOfFrames = @frames.length

    Update: ->
        return if @stopped
        @intervalTime += @game.Loop.updateDelta

        if @intervalTime >= @stepTime
            @AdvanceFrame()

    AdvanceFrame: ->
        @intervalTime = 0
        @index += 1

        @sprite.Bind.Atlas( @atlasId, @textureId, @frames[@index] )

        if @index >= @numberOfFrames - 1

            if @loop
                @index = 0
            else
                @Emit "Finish", new Torch.Event(@game, {animation: @})
                @Trash()

class BindManager
    constructor: (@sprite) ->

    Texture: (textureId, optionalParameters) ->
        tex = null

        # check if the first argument is a string or object
        textureIdType = Util.Type(textureId)

        if textureIdType is "string"
            # fetch a pre-loaded texture
            rawImage = @sprite.game.Assets.GetTexture(textureId)
            tex = new Texture( rawImage )

        else if textureIdType is "object"
            # bind texture directly
            tex = new Texture( textureId )

        else throw new ER.ArgumentError("textureId", textureId, ["string", "object"])

        @sprite.Size.Set(tex.width, tex.height)
        @sprite.texture = tex

    Video: (videoId) ->
        video = null

        # check for a string or object
        videoIdType = Util.Type(videoId)

        if videoIdType is "string"
            # fetch a pre-loaded video
            rawVideo = @sprite.game.Assets.GetVideo(videoId)
            video = new Video( rawVideo )

        else if videoIdType is "object"
            video = new Video( rawVideo )

        else throw new ER.ArgumentError( "videoId", videoId, ["string", "object"] )

        @sprite.video = video
        @sprite.Size.Set(video.width, video.height)

    Atlas: (textureId, textureAtlasId, textureName) ->
        # set it to the texture the atlas is mapped against
        @Texture(textureId)

        #grab the atlas
        textureAtlas = @sprite.game.Assets.GetTextureAtlas(textureAtlasId)

        atlasItem = textureAtlas.textures[textureName]

        # set the clip properties
        @sprite.texture.drawParams.clipX = atlasItem.x
        @sprite.texture.drawParams.clipY = atlasItem.y

        @sprite.texture.drawParams.clipWidth = atlasItem.width
        @sprite.texture.drawParams.clipHeight = atlasItem.height

        # set the sprite width
        @sprite.Size.Set(atlasItem.width, atlasItem.height)

class CanvasRenderer
    constructor: (@sprite) ->
        @game = @sprite.game
        @previousPosition = new Point(@sprite.position.x, @sprite.position.y)
    Draw: ->
        drawRec = new Rectangle(@sprite.position.x, @sprite.position.y, @sprite.rectangle.width, @sprite.rectangle.height)

        drawRec.x = ( @sprite.position.x - @previousPosition.x ) * @game.Loop.lagOffset + @previousPosition.x
        drawRec.y = ( @sprite.position.y - @previousPosition.y ) * @game.Loop.lagOffset + @previousPosition.y
        @previousPosition = new Point(@sprite.position.x, @sprite.position.y)

        cameraTransform = new Point(0,0)

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

TorchModule class Sprite extends GameThing
    Sprite.MixIn(EventDispatcher)

    torch_render_type: "Image"
    torch_type: "Sprite"

    constructor: (game, x, y)->
        @InitSprite(game, x, y)

    InitSprite: (game, x = 0, y = 0)->

        # check the argument types
        gameType = Util.Type(game)
        xType = Util.Type(x)
        yType = Util.Type(y)

        if not game? or gameType isnt "Game"
            throw new ER.ArgumentError("game", game, ["Torch.Game"])

        if xType isnt "number"
            throw new ER.ArgumentError("x", x, ["number"])

        if yType isnt "number"
            throw new ER.ArgumentError("y", y, ["number"])

        @InitEventDispatch()

        @game = game

        @rectangle = new Rectangle(x, y, 0, 0)
        @position = new Vector(x,y)
        @rotationOffset = new Vector( 0, 0 )

        @Bind = new BindManager(@)
        @Collisions = new CollisionManager(@)
        @Body = new BodyManager(@)
        @Size = new SizeManager(@)
        @Events = new EventManager(@)
        @Effects = new EffectManager(@)
        @States = new StateMachineManager(@)
        @Grid = new GridManager(@)
        @Animations = new AnimationManager(@)

        @texture = null
        @video = null

        @fixed = false
        @draw = true
        @paused = false

        @drawIndex = 0
        @rotation = 0
        @opacity = 1

        @_torch_add = "Sprite"
        @_torch_uid = ""

        @events = {}
        @renderer = new CanvasRenderer(@)

        game.Add(@)

    UpdateSprite: ->
        return if @paused
        @rectangle.x = @position.x
        @rectangle.y = @position.y
        @Body.Update()
        @Size.Update()
        @Events.Update()
        @States.Update()
        @Grid.Update()
        @Animations.Update()
        @Effects.Update()
        @Collisions.Update() # this needs to be after the rectangle thing, God knows why

        if @game.boundary and not @rectangle.Intersects( @game.boundary )
            @Emit "OutOfBounds", new Event( @game, { sprite: @ } )

    Update: ->
        @UpdateSprite()

    Draw: ->
        @renderer.Draw()

    NotSelf: (otherSprite) ->
        return (otherSprite.torch_uid isnt @torch_uid)

    Wrap: ->
        @On "OutOfBounds", =>
            return if not @game.boundary

            if @position.y < @game.boundary.y
                @position.y = @game.boundary.height - @rectangle.height

            if @position.y > @game.boundary.height
                @position.y = @game.boundary.y + @rectangle.height

            if @position.x > @game.boundary.width
                @position.x = @game.boundary.x + @rectangle.width

            if @position.x < @game.boundary.x
                @position.x = @game.boundary.width - @rectangle.width

    Clone: ->
        return Object.create( @ )

    Center: ->
        width = @game.canvasNode.width
        x = (width / 2) - (@rectangle.width/2)
        @position.x = x
        return @

    CenterVertical: ->
        height = @game.canvasNode.height
        y = (height / 2) - (@rectangle.height/2)
        @position.y = y
        return @

    CollidesWith: (otherSprite) ->
        return new CollisionDetector(@, otherSprite)

    Pause: (shouldPause = true) ->
        # prevents the sprite from updating
        @paused = shouldPause

if document?
    _measureCanvas = document.createElement("CANVAS")
    _measureCanvas.width = 500
    _measureCanvas.height = 500
else
    _measureCanvas =
        getContext: ->

TorchModule class Text extends Sprite
    TEXT: true
    @measureCanvas: _measureCanvas.getContext("2d")

    # we need properties because the text needs to re-render
    # whenever it is changed
    @property 'fontSize',
        get: -> return @_fontSize
        set: (fontSize) ->
            @_fontSize = fontSize
            Util.Function( => @Render() ).Defer()

    @property 'font',
        get: -> return @_font
        set: (font) ->
            @_font = font
            Util.Function( => @Render() ).Defer()

    @property 'fontWeight',
        get: -> return @_fontWeight
        set: (fontWeight) ->
            @_fontWeight = fontWeight
            Util.Function( => @Render() ).Defer()

    @property 'color',
        get: -> return @_color
        set: (color) ->
            @_color = color
            Util.Function( => @Render() ).Defer()

    @property 'text',
        get: -> return @_text
        set: (text) ->
            @_text = text
            Util.Function( => @Render() ).Defer()

    constructor: (game, x, y, data) ->
        @InitText(game, x, y, data)

    InitText: (game, x, y, data) ->
        @InitSprite(game,x,y)
        @data = data
        @_font = "Arial"
        @_fontSize = 16
        @_fontWeight = ""
        @_color = "#2b4531"
        @_text = ""
        @width = 100
        @height = 100
        @Size.scale = {width: 1, height: 1}
        @Init()

    Init: ->
        if @data.font            then @_font =           @data.font
        if @data.fontSize        then @_fontSize =       @data.fontSize
        if @data.fontWeight      then @_fontWeight =     @data.fontWeight
        if @data.color           then @_color =          @data.color
        if @data.text            then @_text =           @data.text
        if @data.rectangle       then @rectangle =      @data.rectangle
        if @data.buffHeight      then @buffHeight =     @data.buffHeight

        @Render()

    Render: ->
        cnv = document.createElement("CANVAS")
        Text.measureCanvas.font = @_fontSize + "px " + @_font
        cnv.width = Text.measureCanvas.measureText(@_text).width # need to fix this to account for bold fonts
        cnv.height = @_fontSize

        if @buffHeight
            cnv.height += @buffHeight

        canvas = cnv.getContext("2d")
        canvas.fillStyle = @_color
        canvas.font = @_fontWeight + " " + @_fontSize + "px " + @_font
        canvas.fillText(@_text,0,cnv.height)

        # generate the image
        image = new Image()
        image.src = cnv.toDataURL()
        image.onload = =>
                @Bind.Texture(image)

        @rectangle.width = cnv.width
        @rectangle.height = @_fontSize

    Update: ->
        super()

TorchModule class BitmapText
    constructor: ->

###
    We need to have circles, rectangles, lines, and polys
###
Shapes = {name: "Shapes"}

TorchModule Shapes

class Shapes.Circle extends Sprite
    torch_render_type: "Circle"
    radius: 0
    fillColor: "black"
    strokeColor: "black"
    startAngle: 0
    endAngle: 2 * Math.PI
    drawDirection: "clockwise" # or counterclockwise

    constructor: (game, x, y, radius, fillColor = "black", strokeColor = "black")->
        @InitSprite(game, x, y)
        @radius = radius
        @fillColor = fillColor
        @strokeColor = strokeColor

class Shapes.Line extends Sprite
    torch_render_type: "Line" # render it natively
    color: "black"
    lineWidth: 1

    endPosition: null

    constructor: (game, x, y, endX, endY, @color, config) ->
        @InitSprite(game, x, y)

        @endPosition = new Point(endX, endY)

        Util.Object(@).Extend(config)

class Shapes.Box extends Sprite
    torch_render_type: "Box"
    torch_shape: true
    fillColor: "black"
    strokeColor: "black"
    width: 0
    height: 0

    constructor: (game, x, y, width, height, fillColor = "black", strokeColor = "black") ->
        @InitSprite(game, x, y)
        @width = width
        @height = height
        @fillColor = fillColor
        @strokeColor = strokeColor

class Shapes.Polygon extends Sprite
    torch_render_type: "Polygon"
    constructor: (game, x, y, @points, @fillColor, @strokeColor) ->
        @InitSprite(game, x, y)

    @Regular: (game, x, y, sides, width, fillColor, strokeColor) ->
        angleInterval = (Math.PI * 2) / sides
        points = []
        angle = 0

        while angle <= Math.PI * 2

            px = Math.cos(angle) * width
            py = Math.sin(angle) * width

            points.push( new Point(px,py) )

            angle += angleInterval


        shape = new Shapes.Polygon(game, x, y, points, fillColor, strokeColor)
        shape.rectangle.width = shape.rectangle.height = width

        return shape

TorchModule class SpriteGroup extends GameThing
    @MixIn EventDispatcher

    sprites: null
    position: null
    constructor: (@game, x, y) ->
        @InitEventDispatch()
        @game.Add(@)
        @sprites = []
        @position = new Vector(x,y)

    Update: ->
        filtered = []
        for sprite in @sprites
            filtered.push( sprite ) if not sprite.trash

        @sprites = filtered

        if filtered.length <= 0
            @Emit "Empty", new Event(@game, {spriteGroup: @} )

    Every: (calback) ->
        for sprite in @sprites
            calback(sprite)

    Grid: (spriteToCopy, rows, columns, padding = 0) ->
        # TODO
        # support cloning sprites
        # support different widths/heights
        distribution = null
        if Util.Type(spriteToCopy) isnt "array"
            first = new spriteToCopy( @game, @position.x, @position.y )
        else
            distribution = spriteToCopy
            first = new distribution[0]( @game, @position.x, @position.y )

        width = first.rectangle.width
        height = first.rectangle.height

        first.Trash() # this is iffy
        width += padding
        height += padding

        i = 0
        while i < rows

            j = 0
            while j < columns
                if distribution is null
                    copy = new spriteToCopy( @game, @position.x + ( i * width ), @position.y + ( j * height ) )
                else
                    index = Util.Math.RandomInRange(0, distribution.length - 1)
                    index = Math.floor(index)
                    console.log(distribution, index)
                    copy = new distribution[index]( @game, @position.x + ( i * width ), @position.y + ( j * height ) )

                @sprites.push(copy)
                j++

            i++

class CollisionDetector
    constructor: (@sprite, @otherSprite) ->

    AABB: ->
        return new AABB(@sprite, @otherSprite).Execute()

    Circle: ->
        return new Circle(@sprite, @otherSprite).Execute()

    SAT: ->
        return new SAT(@sprite, @otherSprite).Execute()

class AABB
    constructor: (@sprite, @otherSprite) ->

    Execute: ->
        return @sprite.rectangle.Intersects(@otherSprite.rectangle)

class Circle
    constructor: (@sprite, @otherSprite) ->

    Execute: ->
        circle1 =
            radius: @sprite.Width()
            x: @sprite.Position("x")
            y: @sprite.Position("y")

        circle2 =
            radius: @otherSprite.Width()
            x: @otherSprite.Position("x")
            y: @otherSprite.Position("y")

        dx = circle1.x - circle2.x
        dy = circle1.y - circle2.y
        distance = Math.sqrt(dx * dx + dy * dy)

        if distance < circle1.radius + circle2.radius
            #collision detected!
            return true
        return false


Collision =
    AABB: 1
    Circle: 2
    SAT: 3

class CollisionManager
    mode: Collision.AABB
    sprite: null
    filter: null
    limit: null
    enabled: false

    constructor: (@sprite) ->
        @filter = {}
        @game = @sprite.game

    Monitor: ->
        @enabled = true

    NotFiltered: (sprite) ->
        # evaluate the sprite to see if it is filtered out
        # by comparing its attributes with filter objects

        # check game-wide filters
        for key,value of @game.filter
            # check special flag
            if key is "__type__"
                return false if value.constructor.name is sprite.constructor.name
            else
                return false if value is sprite[key]

        # check sprite-specific filters
        for key,value of @filter
            # check special flag
            if key is "__type__"
                return false if value.constructor.name is sprite.constructor.name
            else
                return false if value is sprite[key]

        return true

    InLimit: (sprite) ->
        # evaluate sprite to make sure it has attributes
        # that match limit object

        # check sprite-specific limits
        for key,value of @limit
            # check special flag
            if key is "__type__"
                return true if value.constructor.name is sprite.constructor.name
            else
                return true if value is sprite[key]

        return false

    Valid: (sprite) ->
        if @limit isnt null
            return @InLimit(sprite)

        return @NotFiltered(sprite)

    Filter: (_filter) ->
        @filter = _filter

    Limit: (_limit) ->
        @limit = _limit

    Mode: (_mode) ->
        mode = _mode

    Update: ->
        return if not @sprite.game or not @enabled
        @game = @sprite.game
        anyCollisions = false

        for otherSprite in @game.things
            if otherSprite.torch_type is "Sprite"
                if @sprite.NotSelf(otherSprite) and @Valid(otherSprite)
                    collisionDetected = false
                    collisionData = {}
                    switch @mode
                        when Collision.AABB
                            collisionData = @sprite.CollidesWith(otherSprite).AABB()
                            collisionDetected = collisionData isnt false

                    if collisionDetected
                        collisionData.self = @sprite
                        collisionData.collider = otherSprite
                        anyCollisions == true
                        @sprite.Emit("Collision", new Torch.Event(@game, {collisionData: collisionData}))

        @sprite.Emit("NoCollision", new Torch.Event(@game, {}))

    SimpleCollisionHandle: (event, sink = 1) ->
        offset = event.collisionData
        touching = {left: false, right: false, top: false, bottom: false}
        if offset.vx < offset.halfWidths and offset.vy < offset.halfHeights
            if offset.x < offset.y

                if offset.vx > 0
                    event.collisionData.self.position.x += offset.x * sink
                    touching.left = true
                    #colDir = "l"
                else if offset.vx < 0
                    #colDir = "r"
                    event.collisionData.self.position.x -= offset.x * sink
                    touching.right = true

            else if offset.x > offset.y

                if offset.vy > 0
                    #colDir = "t"
                    event.collisionData.self.position.y += offset.y * sink
                    touching.top = true

                else if  offset.vy < 0
                    #colDir = "b"
                    event.collisionData.self.position.y -= offset.y * sink
                    touching.bottom = true

        return touching

    CastRay: ->
        # ...

class Loop
    constructor: (@game) ->
        @fps = 50
        @frameTime = 1000/@fps
        @lag = 0
        @updateDelta = 0
        @drawDelta = 0
        @lagOffset
    Update: ->
        @game.update(@game)
        @game.State.Update()
        @game.GamePads.Update()
        @game.UpdateThings()

    Draw: ->
        @game.draw(@game)
        @game.DrawThings()


    AdvanceFrame: (timestamp) ->
        if @game.time is undefined
            @game.time = timestamp

        @game.deltaTime = Math.round(timestamp - @game.time)
        @game.time = timestamp
        elapsed = @game.deltaTime
        @drawDelta = elapsed
        @updateDelta = @frameTime

        if elapsed > 1000
            elapsed = @frameTime

        @lag += elapsed

        while @lag >= @frameTime
            @Update()

            @lag -= @frameTime

        @lagOffset = @lag / @frameTime

        @Draw()

        window.requestAnimationFrame (timestamp) =>
            @AdvanceFrame(timestamp)

    Run: (timestamp) ->
        @AdvanceFrame(0)

class AssetManager
    game: null
    textures: null
    audio: null
    video: null
    files: null
    textureAtlases: null

    constructor: (@game) ->
        @textures = {}
        @audio = {}
        @video = {}
        @textureAtlases = {}
        @files = {}

    GetTexture: (id) ->
        return @textures[id]

    GetAudio: (id) ->
        return @audio[id]

    GetVideo: (id) ->
        return @video[id]

    GetTextureAtlas: (id) ->
        return @textureAtlases[id]

    GetFile: (id) ->
        return @files[id]

LoadType = Util.Enum("Texture", "Audio", "Video", "File", "TextureAtlas")

class LoadJob
    constructor: (@loadType, @id, @path) ->

class Load
    # TODO:
    # Warn when assets are overwritten

    @MixIn EventDispatcher

    constructor: (@game) ->
        @InitEventDispatch()

        @files = @game.Assets.files
        @textures = @game.Assets.textures
        @audio = @game.Assets.audio
        @video = @game.Assets.video
        @textureAtlases = @game.Assets.textureAtlases

        @loadJobs = []

        @itemsLeftToLoad = 0
        @progress = 0

        @loaded = false

        @loadLog = ""

    Audio: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.Audio, id, path) )

    Texture: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.Texture, id, path) )

    TextureAtlas: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.TextureAtlas, id, path) )

    Video: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.Video, id, path) )

    File: (path, id) ->
        @loadJobs.push( new LoadJob(LoadType.File, id, path) )

    Font: (path, name) ->
        # this can be done right off the bat
        style = document.createElement("style")
        manualLoader = document.createElement("p")

        cssFontRule = """
            @font-face{
                font-family: #{name};
                src: url(#{path});
            }
        """
        cssFontRule = document.createTextNode(cssFontRule)
        style.appendChild(cssFontRule)

        manualLoader.innerHTML = "TEST"
        manualLoader.style.fontFamily = name

        document.head.appendChild(style)
        document.body.appendChild(manualLoader)

        #manualLoader.parentNode.removeChild(manualLoader)

    LoadItemFinished: ->
        @itemsLeftToLoad -= 1

        @progress = (@totalLoad - @itemsLeftToLoad) / @totalLoad

        @game.Emit "LoadProgressed", new Event @game,
            progress: @progress

        if @itemsLeftToLoad <= 0
            # load has finished
            document.getElementsByClassName("font-loader")[0]?.remove()
            timeToLoad = (new Date().getTime() - @startTime) / 1000

            @Emit "LoadFinished", new Event @game,
                timeToLoad: timeToLoad

            # successful load
            console.log "%c#{@game.name} loaded in #{timeToLoad}s",
                """background-color:green;
                   color:white;
                   padding:2px;
                   padding-right:5px;
                   padding-left:5px"""

    Load: ->
        @totalLoad = @loadJobs.length
        @itemsLeftToLoad = @totalLoad

        @startTime = new Date().getTime()

        try
            for loadJob in @loadJobs

                switch loadJob.loadType

                    when LoadType.Texture
                        @LoadTexture(loadJob)

                    when LoadType.Video
                        @LoadVideo(loadJob)

                    when LoadType.Audio
                        @LoadAudio(loadJob)

                    when LoadType.File
                        @LoadFile(loadJob)

                    when LoadType.TextureAtlas
                        @LoadTextureAtlas(loadJob)

        catch e
            console.log "%c#{@game.name} could not load!",
                        """background-color:#{Color.Ruby};
                           color:white;
                           padding:2px;
                           padding-right:5px;
                           padding-left:5px"""
            Torch.FatalError(e)

    LoadTexture: (loadJob) ->
        im = new Image()
        im.src = loadJob.path

        @textures[loadJob.id] = im

        im.onload = =>
            @LoadItemFinished()

    LoadTextureAtlas: (loadJob) ->
        loader = new Torch.AjaxLoader(loadJob.path, Torch.AjaxData.Text)
        loader.loadJob = loadJob
        loader.Finish (data, loader) =>
            @LoadItemFinished()
            @textureAtlases[loader.loadJob.id] = JSON.parse(data)
        loader.Load()

    LoadVideo: (loadJob) ->
        video = document.createElement("video")
        video.src = loadJob.path

        @video[loadJob.id] = video

        video.addEventListener "loadeddata", =>
            @LoadItemFinished()

    LoadAudio: (loadJob) ->
        loader = new Torch.AjaxLoader(loadJob.path, Torch.AjaxData.ArrayBuffer)
        loader.loadJob = loadJob
        loader.Finish (data, loader) =>
            @audio[loader.loadJob.id] = {}
            @audio[loader.loadJob.id].encodedAudioData = data
            @game.Audio.DecodeAudioData data, (buffer) =>
                @audio[loader.loadJob.id].audioData = buffer
                @LoadItemFinished()
        loader.Load()

    LoadFile: (loadJob) ->
        loader = new Torch.AjaxLoader(loadJob.path, Torch.AjaxData.Text)
        loader.loadJob = loadJob
        loader.Finish (data, loader) =>
            @LoadItemFinished()
            @files[loader.loadJob.id] = data
        loader.Load()

class Timer
    constructor: (@game)->

    SetFutureEvent: (timeToOccur, handle) ->
        ev = new FutureEvent(timeToOccur, handle, @game)
        @game.Add( ev )

        return ev

    SetScheduledEvent: (interval, handle) ->
        ev = new ScheduledEvent(interval, handle, @game)
        @game.Add( ev )

        return ev

class FutureEvent extends GameThing

    constructor: (@timeToOccur, @handle, @game) ->
        @time = 0
    Update: ->
        @time += @game.Loop.updateDelta
        if @time >= @timeToOccur
            if @handle isnt null and @handle isnt undefined
                @handle()
                @handle = null

class ScheduledEvent extends GameThing

    constructor: (@interval, @handle, @game) ->
        @elapsedTime = 0

    Update: ->
        @elapsedTime += @game.Loop.updateDelta

        if @elapsedTime >= @interval
            @handle() if @handle?
            @elapsedTime = 0

class Mouse
    constructor: (@game) ->
        @x = 0
        @y = 0
        @down = false

    SetMousePos: (c, evt) ->
        rect = c.getBoundingClientRect()
        @x = evt.clientX - rect.left
        @y = evt.clientY - rect.top

    GetRectangle: ->
        return new Rectangle(@x, @y, 5, 5)

    SetCursor: (textureId) ->
        texture = @game.Assets.GetTexture( textureId )

        @game.canvasNode.style.cursor = "url(#{texture.src}), auto"

class Camera
    position: null
    _jerkFollow: null
    constructor: (@game) ->
        @position = new Point(0,0)
        @Viewport = new Viewport(@)

    JerkFollow: (sprite, offset = 5, config) ->
        if not config?
            config =
                maxLeft: -500
                maxRight: 2000
                maxTop: -500
                maxBottom: 2000

        @_jerkFollow = new JerkFollow(@, sprite, offset, config)
        @game.Add( @_jerkFollow )

class Viewport
    width: 0
    height: 0
    maxWidth: 0
    maxHeight: 0
    constructor: (@camera) ->
        @maxWidth = @width = window.innerWidth
        @maxHeight = @height = window.innerHeight
        @rectangle = new Rectangle(@camera.position.x, @camera.position.y, @width, @height)

    Update: ->
        @rectangle.x = @camera.position.x
        @rectangle.y = @camera.position.y
        @rectangle.width = @width
        @rectangle.height = @height

class JerkFollow extends GameThing
    boundLeft: 0
    boundRight: 0
    boundTop: 0
    boundBottom: 0
    Inc: 0

    constructor: (@camera, @sprite, offset, @config) ->
        v = @camera.Viewport
        @game = @camera.game
        @Inc = v.width / offset
        @boundLeft = v.width / offset
        @boundRight = v.width - @boundLeft
        @boundTop = 0

    Update: ->
        if @sprite.position.x >= @boundRight

            if @sprite.position.x >= @config.maxRight
                @sprite.position.x = @boundRight
                return

            @boundRight += @Inc
            @boundLeft += @Inc

            @game.Tweens.Tween( @camera.position, 500, Torch.Easing.Smooth ).To({x: @camera.position.x - @Inc})

        if @sprite.position.x <= @boundLeft

            if @sprite.position.x <= @config.maxLeft
                @sprite.position.x = @boundLeft
                return

            @boundRight -= @Inc
            @boundLeft -= @Inc

            @game.Tweens.Tween( @camera.position, 500, Torch.Easing.Smooth ).To({x: @camera.position.x + @Inc})

        if @sprite.position.y <= @boundTop

            if @sprite.position.y <= @config.maxTop
                @sprite.position.y = @boundTop
                return

            @boundTop -= @Inc
            @boundBottom -= @Inc

            @game.Tweens.Tween( @camera.position, 500, Torch.Easing.Smooth ).To({x: @camera.position.y + @Inc})

class Layer
    constructor: (@drawIndex)->
        @children = []
        @mapIndex - @drawIndex

    DrawIndex: (index) ->
        return @drawIndex if not index

        @drawIndex = index
        for child in @children
            child.DrawIndex(index)

        return @

    Add: (child) ->
        child.DrawIndex(@index)
        @children.push(child)

class Layers
    constructor: (@game) ->
        @layers = []
        @layerMap = {}

    Add: (layerName) ->
        layer = null
        if typeof layerName is "string"
            layer = new Layer( @layers.length )
            @layerName[layerName] = layer
            @layers.add( layer )
        else
            for name in layerName
                layer = new Layer( @layers.length )
                @layerMap[name] = layer
                @layers.add( layer )

    Remove: (layerName, tryToFill) ->
        if not @layerMap[layerName]
            Torch.FatalError("Unable to remove layer '#{ layerName }'. Layer does not exist")

        else
            cleanedLayers = []
            layer = layerMap[layerName]
            layer.Trash()

            delete @layerMap[layerName]

            for item,index in @layers
                l = cleanedLayers[index]

                if index isnt layer.mapIndex
                    cleanedLayers.push(l)
                    l.DrawIndex( l.DrawIndex() - 1 ) if tryToFill


    Get: (layerName) ->
        if not @layerMap[layerName]
            Torch.FatalError("Unable to get layer '#{ layerName }'. Layer does not exist")

        else return @layerMap[layerName]

class Key
    Key.MixIn(EventDispatcher)

    down : false
    constructor: (@keyCode) ->
        @InitEventDispatch()



class Keys
    Keys.MixIn(EventDispatcher)

    constructor: ->
        @specialKeys =
            8: "Delete"
            9: "Tab"
            13: "Enter"
            16: "Shift"
            17: "Control"
            18: "Alt"
            19: "PauseBreak"
            20: "CapsLock"
            27: "Escape"
            32: "Space"
            33: "PageUp"
            34: "PageDown"
            35: "End"
            36: "Home"
            37: "LeftArrow"
            38: "UpArrow"
            39: "RightArrow"
            40: "DownArrow"
            45: "Insert"
            46: "Delete2"
            48: "Num0"
            49: "Num1"
            50: "Num2"
            51: "Num3"
            52: "Num4"
            53: "Num5"
            54: "Num6"
            55: "Num7"
            56: "Num8"
            57: "Num9"
            96: "NumPad0"
            97: "NumPad1"
            98: "NumPad2"
            99: "NumPad3"
            100: "NumPad4"
            101: "NumPad5"
            102: "NumPad6"
            103: "NumPad7"
            104: "NumPad8"
            105: "NumPad9"
            106: "NumPadMultiply"
            107: "NumPadPlus"
            109: "NumPadMinus"
            110: "NumPadPeriod"
            111: "NumPadDivide"
            112: "F1"
            113: "F2"
            114: "F3"
            115: "F4"
            116: "F5"
            117: "F6"
            118: "F7"
            119: "F8"
            120: "F9"
            121: "F10"
            122: "F11"
            123: "F12"
            144: "NumLock"
            145: "ScrollLock"
            186: "Colon"
            187: "NumPlus"
            188: "Comma"
            189: "NumMinus"
            190: "Period"
            191: "ForwardSlash"
            192: "Tilda"
            219: "BracketLeft"
            221: "BracketRight"
            220: "BackSlash"
            222: "Quote"

        @InitKeys()

    SpecialKey: (keyCode) ->
        for key,value of @specialKeys
            if keyCode.toString() is key.toString()
                return @[value]

        return null

    InitKeys: ->
        _keys = @
        i = 0
        while i < 230
            _char = String.fromCharCode(i).toUpperCase()
            _keys[_char] = new Key(i)
            i++

        for keyCode,value of @specialKeys
            _keys[value] = new Key(keyCode)

class Tween extends GameThing
    @MixIn EventDispatcher

    objectToTween: null
    tweenProperties: null
    originalObjectValues: null
    elapsedTime: 0
    timeTweenShouldTake: 0
    easing: null
    repeat: false
    cycle: false

    constructor: (@game, @objectToTween, @tweenProperties, @timeTweenShouldTake, @easing) ->
        @InitEventDispatch()
        @game.Tweens.tweens.push(@)
        @game.Add( @ )

        @originalObjectValues = {}

        for key,value of @tweenProperties
            @originalObjectValues[key] = @objectToTween[key]
    Update: ->
        normalizedTime = @elapsedTime / @timeTweenShouldTake
        easedTime = @Ease(normalizedTime)

        for key,value of @tweenProperties
            @objectToTween[key] = (@tweenProperties[key] * easedTime) + (@originalObjectValues[key] * (1 - easedTime))

        @elapsedTime += @game.Loop.updateDelta
        if @elapsedTime >= @timeTweenShouldTake
            @Emit "Finish", new Torch.Event(@game, {tween: @})

            if @cycle
                @elapsedTime = 0
                tmp = Object.create( @originalObjectValues )
                @originalObjectValues = Object.create( @tweenProperties)
                @tweenProperties = tmp

            else
                @Trash()

    Cycle: ->
        @cycle = true
        return @

    Ease: (normalizedTime) ->
        switch @easing
            when Torch.Easing.Linear
                return normalizedTime

            when Torch.Easing.Square
                return Math.pow(normalizedTime, 2)

            when Torch.Easing.Cube
                return Math.pow(normalizedTime, 3)

            when Torch.Easing.InverseSquare
                return 1 - Math.pow(1 - normalizedTime, 2)

            when Torch.Easing.InverseCube
                return 1 - Math.pow(1 - normalizedTime, 3)

            when Torch.Easing.Smooth
                return normalizedTime * normalizedTime * (3 - 2 * normalizedTime)

            when Torch.Easing.SmoothSquare
                return Math.pow( ( normalizedTime * normalizedTime * ( (3 - 2 * normalizedTime) ) ), 2 )

            when Torch.Easing.SmoothCube
                return Math.pow( ( normalizedTime * normalizedTime * ( (3 - 2 * normalizedTime) ) ), 3 )

            when Torch.Easing.Sine
                return Math.sin(normalizedTime * Math.PI / 2)

            when Torch.Easing.InverseSine
                return 1 - Math.sin( (1 - normalizedTime) * Math.PI / 2 )

class TweenSetup
    constructor: (@game, @object, @timeTweenShouldTake, @easing) ->

    To: (tweenProperties) ->
        return new Tween(@game, @object, tweenProperties, @timeTweenShouldTake, @easing)

    From: (setProperties) ->
        for key,value of setProperties
            @object[key] = value
        return @

class TweenManager
    constructor: (@game) ->
        @tweens = []

    Tween: (object, timeTweenShouldTake, easing = Torch.Easing.Smooth) ->
        return new TweenSetup(@game, object, timeTweenShouldTake, easing)

    All: (callback) ->
        for tween in @game.tweens
            callback(tween)

# # objects or primitives
# game.Tween(sprite.position, 500).To({x: 500, y: 500})
# # or set the properties before tweening
# game.Tween.(sprite.opacity, 500).From(0).To(1)

class ParticleEmitter extends Sprite
    particle: null
    auto: true
    constructor: (@game, x, y, @interval, @loop, @particle, @config) ->
        @InitSprite(@game, x, y)
        @elapsedTime = 0
        @hasEmitted = false

    Update: ->
        super()
        if @interval isnt undefined
            if @hasEmitted
                if @loop then @UpdateParticleEmitter()
            else @UpdateParticleEmitter()


    Particle: (particle) ->
        particle = particle

    UpdateParticleEmitter: ->
        return if not @auto
        @elapsedTime += @game.Loop.updateDelta

        if @elapsedTime >= @interval
            @EmitParticles()
            @hasEmitted = true
            @elapsedTime = 0

    EmitParticles: (removeEmitterWhenDone = false) ->
        i = 0
        while i < @config.spread
            i++
            @EmitParticle()

        if removeEmitterWhenDone then @Trash()

    EmitParticle: ()->
        angle = Util.Math.RandomInRange(@config.minAngle, @config.maxAngle)
        scale = Util.Math.RandomInRange(@config.minScale, @config.maxScale)
        alphaDecay = Util.Math.RandomInRange(@config.minAlphaDecay, @config.maxAlphaDecay)
        radius = Util.Math.RandomInRange(@config.minRadius, @config.maxRadius)
        x = @position.x
        y = @position.y

        if typeof @particle isnt "string"
            p = new @particle(@game, x, y)
        else
            p = @game.Factory.Sprite( x, y, @particle )

        #p.Body.acceleration.y = @config.gravity
        p.Body.velocity.x = Math.cos(angle) * Util.Math.RandomInRange(@config.minVelocity, @config.maxVelocity)
        p.Body.velocity.y = Math.sin(angle) * Util.Math.RandomInRange(@config.minVelocity, @config.maxVelocity)
        p.Body.omega = Util.Math.RandomInRange(@config.minOmega, @config.maxOmega)
        p.Size.Scale(scale, scale)
        p.drawIndex = 1000

        @game.Tweens.Tween(p, alphaDecay, Torch.Easing.Smooth)
            .To({opacity: 0})
            .On "Finish", ->
                p.Trash()

class ParticleManager
    constructor: (@game) ->

    ParticleEmitter: (x, y, interval, shouldLoop, particle, config)->
        return new ParticleEmitter(@game, x, y, interval, shouldLoop, particle, config)


# # usage
# emitter = new Torch.ParticleEmitter game, 0, 0, 1000, true,
#     spread: 20
#     gravity: 0.1
#     minRadius: 1
#     maxRadius: 2
#     minAngle: 0
#     maxAngle: Math.PI * 2
#     minScale: 1
#     maxScale: 2
#     minVelocity: 1
#     maxVelocity: 2
#     minAlphaDecay: 100
#     maxAlphaDecay: 200
#     minOmega: 1
#     maxOmega: 2
# emitter.Particle EffectPieces.Fire, (particle) ->
#     # do something to the particle when it's emitted
#
#
# emitter.Body.velocity.x = 5

class Sound
    volume: 1
    pan: 0
    constructor: (@soundId) ->
class Audio
    audioContext: null
    MasterVolume: 1
    constructor: (@game) ->
        @GetAudioContext()

    GetAudioContext: ->
        try
            window.AudioContext = window.AudioContext or window.webkitAudioContext;
            @audioContext = new AudioContext()

        catch e
            console.warn("Unable to initialize audio...")

    DecodeAudioData: (data, callback) ->
        @audioContext.decodeAudioData data, (buffer) ->
            callback(buffer)

    CreateAudioPlayer: ->
        return new AudioPlayer(@)

class AudioPlayer
    volume: 1
    constructor: (aud) ->
        @audioContext = aud.audioContext
        @game = aud.game

    CreateGain: (gain = 1) ->
        gainNode = @audioContext.createGain()
        gainNode.gain.value = gain
        return gainNode

    Play: (sound) ->
        @game.FatalError("Cannot play sound. sound must be Torch.Sound")

    PlaySound: (id, time = 0, filters = null) ->
        source = @audioContext.createBufferSource()
        source.buffer = @game.Assets.audio[id].audioData

        if @game.Audio.MasterVolume isnt 1
            if filters is null
                filters = [@CreateGain(@game.Audio.MasterVolume)]
            else
                filters.push(@CreateGain(@game.Audio.MasterVolume))

        if filters is null
            filters = [@CreateGain(@volume)]
        else
            filters = [filters..., @CreateGain(@volume)]

        lastFilter = null

        for filter,index in filters
            if lastFilter is null
                source.connect(filter)
            else
                lastFilter.connect(filter)

            lastFilter = filter

            if index is filters.length - 1
                filter.connect(@audioContext.destination)
                source.start(time)
                return

        source.connect(@audioContext.destination)
        source.start(time)

class HookManager
    positionTransform: null

    constructor: (@game) ->
        @positionTransform = new Point(0,0)

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

class GamePad
    @MixIn EventDispatcher

    connected: false
    buttons: null
    sticks: null

    constructor: (@game, @index) ->
        @InitEventDispatch()
        @buttons =
            A: new GamePadButton(@, 1)
            B: new GamePadButton(@, 2)
            X: new GamePadButton(@, 3)
            Y: new GamePadButton(@, 4)
            LeftBumper: new GamePadButton(@, 5)
            RightBumper: new GamePadButton(@, 6)
            LeftTrigger: new GamePadButton(@, 7)
            RightTrigger: new GamePadButton(@, 8)
            Back: new GamePadButton(@, 9)
            Start: new GamePadButton(@, 10)
            LeftStick: new GamePadButton(@, 11)
            RightStick: new GamePadButton(@, 12)
            DPadUp: new GamePadButton(@, 13)
            DPadDown: new GamePadButton(@, 14)
            DPadLeft: new GamePadButton(@, 15)
            DPadRight: new GamePadButton(@, 16)


        @buttonMap = ["A", "B", "X", "Y", "LeftBumper", "RightBumper",
                        "LeftTrigger", 'RightTrigger', "Back", "Start",
                        "LeftStick", "RightStick", "DPadUp", "DPadDown",
                        "DPadLeft", "DPadRight"
                     ]

        @sticks =
            LeftStick: new GamePadStick(@)
            RightStick: new GamePadStick(@)

    SetState: (nativeGamePad) ->
        @connected = nativeGamePad.connected
        for nativeButton,index in nativeGamePad.buttons
            button = @buttons[ @buttonMap[index] ]

            if button?
                button.SetState(nativeButton)

        axes = nativeGamePad.axes
        @sticks.LeftStick.SetState( axes[0], axes[1] )
        @sticks.RightStick.SetState( axes[2], axes[3] )


class GamePadManager
    _pads: null
    constructor: (@game) ->
        @_pads = [new GamePad(@game),new GamePad(@game),new GamePad(@game),new GamePad(@game)]

    Pad: (index) ->
        return @_pads[index]

    Update: ->
        nativeGamePads = navigator.getGamepads()

        for pad,index in nativeGamePads

            if pad?
                @_pads[index].SetState(pad)

class GamePadButton
    @MixIn EventDispatcher
    _wasDown: false
    down: false

    constructor: (@gamePad, @buttonCode) ->
        @InitEventDispatch()
        @game = @gamePad.game

    SetState: (nativeGamePadButton) ->
        if @_wasDown and not nativeGamePadButton.pressed
            @Emit "ButtonPressed", new Torch.Event(@game, {button: @})

        @down = nativeGamePadButton.pressed
        @_wasDown = @down

class GamePadStick
    @MixIn EventDispatcher
    horizontalAxis: 0
    verticalAxis: 0
    EPSILON: 0.1

    constructor: (@gamePad) ->

    SetState: (horizontalAxis, verticalAxis) ->
        if Math.abs(horizontalAxis) > @EPSILON
            @horizontalAxis = horizontalAxis
        else
            @horizontalAxis = 0

        if Math.abs(verticalAxis) > @EPSILON
            @verticalAxis = verticalAxis
        else
            @verticalAxis = 0

class CanvasGame
    torch_type: "Game"
    constructor: (@canvasId, @width, @height, @name, @graphicsType, @pixel = 0) ->
        @InitGame()

    CanvasGame.MixIn(EventDispatcher)

    InitGame: ->
        @InitEventDispatch()
        @InitGraphics()
        @InitComponents()
        @Style()

    InitComponents: ->
        styleString = "background-color:#{Color.Flame.GetHtmlString()}; color:#{Color.Ruby.GetHtmlString()}; font-weight: bold; padding:2px; padding-right:5px;padding-left:5px"
        graphicsString = "WebGL"

        if @graphicsType is Torch.CANVAS then graphicsString = "Canvas"

        console.log("%c Torch v#{Torch::version} |#{graphicsString}| - #{@name}", styleString)

        @Loop = new Loop(@)
        @Assets = new AssetManager(@)
        @Load = new Load(@)
        @Mouse = new Mouse(@)
        @Timer = new Timer(@)
        @Camera = new Camera(@)
        @Layers = new Layers(@)
        @Keys = new Keys(@)
        @Tweens = new TweenManager(@)
        @Particles = new ParticleManager(@)
        @Audio = new Audio(@)
        @Hooks = new HookManager(@)
        @Factory = new GameThingFactory(@)
        @State = new StateMachine(@)
        @GamePads = new GamePadManager(@)

        @deltaTime = 0
        @fps = 0
        @averageFps = 0
        @allFPS = 0
        @ticks = 0
        @zoom = 1
        @uidCounter = 0

        @paused = false

        @boundary = null
        @time = null
        @LastTimeStamp = null

        @things = []
        @DrawStack = []
        @AddStack = []

        @thingMap = {}
        @filter = {}

    InitGraphics: ->
        @canvasNode = document.createElement("CANVAS")
        @canvasNode.width = window.innerWidth
        @canvasNode.height = window.innerHeight

        document.getElementById(@canvasId).appendChild(@canvasNode)

        @canvas = @canvasNode.getContext("2d")
        @Clear("#cc5200")

    PixelScale: ->
        @canvas.mozImageSmoothingEnabled = false
        @canvas.imageSmoothingEnabled = false

        return @

    Start: (configObject) ->
        defaultConfigObject =
            Load: ->
            Update: ->
            Draw: ->
            Init: ->

        Util.Object( defaultConfigObject ).Extend(configObject)

        @load = defaultConfigObject.Load
        @update = defaultConfigObject.Update
        @draw = defaultConfigObject.Draw
        @init = defaultConfigObject.Init

        @load(@)

        @Load.Load()
        @Load.On "LoadFinished", =>
            @init(@)
            @WireUpEvents()
            @Run()

        @canvasNode.width = @width
        @canvasNode.height = @height

        if typeof(@width) is "string"
            @canvasNode.width = document.body.clientWidth

        if typeof(@height) is "string"
            @canvasNode.height = document.body.clientHeight

    Add: (o) ->
        if not o.torch_game_thing
            throw new ER.ArgumentError()

        @uidCounter++
        o.torch_uid = "thing#{@uidCounter}"
        o.torch_add_order = @uidCounter

        @AddStack.push(o)

    GetById: (id) ->
        return @thingMap[id]

    Run: (timestamp) ->
        @Loop.Run(0)

    FatalError: (error) ->
        if @fatal
            return

        @fatal = true

        if typeof error == "string"
            error = new Error(error)

        @Clear("#000")
        stack = error.stack.replace(/\n/g, "<br><br>")
        errorHtml = """
        <code style='color:#C9302Cmargin-left:15%font-size:24px'>#{error}</code>
        <br>
        <code style='color:#C9302Cfont-size:20pxfont-weight:bold'>Stack Trace:</code>
        <br>
        <code style='color:#C9302Cfont-size:20px'>#{stack}</code>
        <br>
        <code style='color:#C9302Cfont-size:18px'>Time: #{@time}</code>
        """
        document.body.innerHTML = errorHtml

        @RunGame = ->
        @Run = ->
        @Emit "FatalError", new Torch.Event @,
            error: error
        throw error

    UpdateThings: ->
        filtered = []
        for thing in @things
            if not thing.trash
                if not thing.paused
                    thing.Update()
                    filtered.push(thing)
            else
                thing.trashed = true

                if thing.Emit?
                    thing.Emit "Trash", new Torch.Event(@)

        @things = filtered
        @things = @things.concat( @AddStack )
        @AddStack = []

    DrawThings: ->
        # we need to clear the entire screen
        @canvas.clearRect(0, 0, @Camera.Viewport.maxWidth, @Camera.Viewport.maxHeight)

        @things.sort (a, b) ->
            if a.drawIndex is b.drawIndex
                return a.torch_add_order - b.torch_add_order

            return a.drawIndex - b.drawIndex

        for sprite in @things
            if not sprite.trash
                sprite.Draw()

    Clear: (color) ->
        if color is undefined
            @FatalError("Cannot clear undefined color")
        if typeof color is "object"
            color = color.hex

        @canvasNode.style.backgroundColor = color
        return @

    SetBoundaries: ( x, y, width, height ) ->
        @boundary = new Rectangle( x, y, width, height )

    getCanvasEvents: ->
        evts = [
            [
                "mousemove", (e) =>
                    @Mouse.SetMousePos(@canvasNode, e)
                    @Emit "MouseMove", new Torch.Event @,
                        nativeEvent: e
            ]
            [
                "mousedown", (e) =>
                    @Mouse.down = true
                    @Emit "MouseDown", new Torch.Event @,
                        nativeEvent: e
            ]
            [
                "mouseup", (e) =>
                    @Mouse.down = false
                    @Emit "MouseUp", new Torch.Event @,
                        nativeEvent: e
            ]
            [
                "touchstart", (e) =>
                    @Mouse.down = true

            ]
            [
                "touchend", (e) =>
                    @Mouse.down = false
            ]
            [
                "click", (e) =>
                    e.preventDefault()
                    e.stopPropagation()
                    @Emit "Click", new Torch.Event @,
                        nativeEvent: e
                    return false
            ]
        ]

        return evts

    getBodyEvents: ->
        bodyEvents =
        [
            [
                "keydown", (e) =>
                    c = e.keyCode
                    key = @Keys.SpecialKey(c)

                    if key is null
                        key = @Keys[String.fromCharCode(e.keyCode).toUpperCase()]

                    key.down = true
                    key.Emit("KeyDown", new Torch.Event(@, {nativeEvent: e}))

            ]
            [
                "keyup", (e) =>
                    c = e.keyCode
                    key = @Keys.SpecialKey(c)

                    if key is null
                        key = @Keys[String.fromCharCode(e.keyCode).toUpperCase()]

                    key.down = false
                    key.Emit("KeyUp", new Torch.Event(@, {nativeEvent: e}))
            ]
        ]
        return bodyEvents

    WireUpEvents: ->
        for eventItem in @getCanvasEvents()
            @canvasNode.addEventListener(eventItem[0], eventItem[1], false)

        for eventItem in @getBodyEvents()
            document.body.addEventListener(eventItem[0], eventItem[1], false)

        # window resize event
        resize = (event) =>
            @Emit "Resize", new Torch.Event @,
                nativeEvent: event

        window.addEventListener( 'resize', resize, false )

        pads = navigator.getGamepads()

    TogglePause: ->
        if not @paused
            @paused = true
        else
            @paused = false
        return @

    Style: ->
        # a few style fixes to get around having a css file

        body = document.body

        body.style.backgroundColor = "black"
        body.style.overflow = "hidden"
        body.style.margin = 0

        canvas = document.getElementsByTagName("CANVAS")[0]
        canvas.style.cursor = "pointer"

# class Game
#     constructor: (canvasId, width, height, name, graphicsType, pixel) ->
#
#         return new Torch.CanvasGame(canvasId, width, height, name, graphicsType, pixel) if graphicsType is Torch.CANVAS
#         return new Torch.WebGLGame(canvasId, width, height, name, graphicsType, pixel)  if graphicsType is Torch.WEBGL

Game = CanvasGame

TorchModule Game, "Game"

TorchModule class Texture
    image: null
    drawParams: null
    width: 0
    height: 0

    constructor: (@image) ->
        @width = @image.width
        @height = @image.height
        @drawParams = new DrawParams(@width, @height)

class DrawParams
    clipX: 0
    clipY: 0
    clipWidth: 0
    clipHeight: 0

    constructor: (@clipWidth, @clipHeight) ->

TorchModule class Video
    video: null
    drawParams: null
    width: 0
    height: 0

    constructor: (@video) ->
        @width = @video.videoWidth
        @height = @video.videoHeight

        @drawParams = new DrawParams(@width, @height)

    Play: ->
        @video.play()

        return @

    Stop: ->
        @video.stop()

        return @

    Loop: (turnOn = true)->
        @video.loop = turnOn

        return @

TorchModule class StateMachine
    constructor: (@obj) ->
        @currentState = null
        @states = {}
        @game = @obj.game

    State: (stateName, stateObj) ->
        if stateObj is undefined

            if @states[stateName] is undefined
                Torch.FatalError("Unable to get state. State '#{stateName}' has not been added to the state machine")
            return @states[stateName]

        else
            stateObj.stateMachine = @
            stateObj.game = @game
            @states[stateName] = stateObj

    AddState: (stateName, stateObj) ->
        @states[stateName] = stateObj
        stateObj.game = @game
        stateObj.stateMachine = @

    Switch: (newState, args...) ->
        if @currentState and @currentState.End isnt undefined
            @currentState.End(@obj, args...)

        if @State(newState).Start isnt undefined
            @State(newState).Start(@obj, args...);

        @currentState = @State(newState);

    Update: ->
        if @currentState isnt null and @currentState isnt undefined
            @currentState.Execute(@obj);

class State
    constructor: (@Execute, @Start, @End) ->

TorchModule class Color
    hex: null
    r: null
    g: null
    b: null
    constructor: (rOrHex, g, b) ->
        @Set(rOrHex, g, b)

    Set: (rOrHex, g, b) ->
        if typeof rOrHex is "string"
            @hex = rOrHex
            @DecodeHex()
        else
            @r = rOrHex
            @g = g
            @b = b
            @EncodeHex()

    DecodeHex: ->
        chunks = Util.String(@hex).Chunk(2)

        @r = parseInt(chunks[0], 16)
        @g = parseInt(chunks[1], 16)
        @b = parseInt(chunks[2], 16)

    EncodeHex: ->
        @hex = ""
        @hex += @r.toString(16)
        @hex += @g.toString(16)
        @hex += @b.toString(16)

    GetHtmlString: ->
        return "#" + @hex

    Invert: ->
        @Set( Math.floor( Math.abs( 255 - @r ) ), Math.floor( Math.abs( 255 - @g ) ), Math.floor( Math.abs( 255 - @b ) ) )

    # static color methods

    @Random: ->
        return new Color( Math.floor( Util.Math.RandomInRange(0,255) ), Math.floor( Util.Math.RandomInRange(0,255) ), Math.floor( Util.Math.RandomInRange(0,255) ) )

Color.Red = new Color(256, 0, 0, 1)
Color.Green = new Color(0, 256, 0, 1)
Color.Blue = new Color(0, 0, 256, 1)
Color.Flame = new Color("ff8000")
Color.Ruby = new Color("e60000")

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

exports = this # this will either be 'window' for Chrome or
               # 'module' for node

###
    A few notes to keep in mind:

    - CoffeeScript wraps each file into it's own scope when it is compiled into
      javascript. When Torch is built, it puts all the coffeescript into one file
      (torch-latest.coffee) thus throwing all of Torch into the same scope. The only
      piece that is exposed is an instance of Torch called 'Torch'

    - There are a few custom objects that are defined in the torch scope a little odly:
       - Util - An instance of Utilities, used internally by Torch, exported as Torch.Util
###
class Event
    constructor: (@game, @data) ->
        if @game isnt null
            @time = @game.time
        for key,value of @data
            @[key] = value

class Torch

    CANVAS: 1
    WEBGL: 2
    PIXEL: 3

    DUMP_ERRORS: false

    @GamePads: Util.Enum("Pad1", "Pad2", "Pad3", "Pad4")
    @AjaxData: Util.Enum("DOMString", "ArrayBuffer", "Blob", "Document", "Json", "Text")
    @Types: Util.Enum("String", "Number", "Object", "Array", "Function", "Sprite", "Game", "Null")
    @Easing: Util.Enum("Linear", "Square", "Cube", "InverseSquare", "InverseCube",
                        "Smooth", "SmoothSquare", "SmoothCube", "Sine", "InverseSine")

    @AjaxLoader: AjaxLoader
    @Event: Event
    @Util: new Utilities() # a static reference for use within torch

    constructor: ->
        @GamePads = Torch.GamePads
        @AjaxData = Torch.AjaxData
        @Types = Torch.Types
        @Easing = Torch.Easing

        @Util = Util

        for mod in TorchModules
            @[mod.name] = mod.mod

    @FatalError: (error) ->
        return if @fatal
        @fatal = true

        if Util.Type(error) is "string"
            error = new Error(error)
        else if not error.stack?
            error = error.nativeError

        document.body.backgroundColor = "black"

        if @DUMP_ERRORS
            if require isnt undefined
                require("fs").writeFileSync("torch-error.log", error.stack)

        stack = error.stack.replace(/\n/g, "<br><br>")

        errorHtml = """
        <code style='color:#C9302C;margin-left:15%;font-size:24px'>#{error}</code>
        <br>
        <code style='color:#C9302C;font-size:20px;font-weight:bold'>Stack Trace:</code><br>
        <code style='color:#C9302C;font-size:20px'>#{stack}</code><br>
        """
        document.body.innerHTML = errorHtml

    StrictErrors: ->
        @STRICT_ERRORS = true

    DumpErrors: ->
        @DUMP_ERRORS = true

exports.Torch = new Torch()


Torch::version = '0.9.162'
