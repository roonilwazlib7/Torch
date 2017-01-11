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
