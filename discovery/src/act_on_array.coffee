module.exports = class Thing

    constructor: (@result) -> 

    do: (duration, callback) -> 

        setTimeout =>

            callback null, @result 

        , duration

    @doo: (instance, duration, callback) -> 

        console.log 'on', instance

        setTimeout ->

            #console.log instance
            callback null, instance.result 

        , duration

    @fails: (instance, duration, callback) -> 

        setTimeout ->

            callback new Error(instance.result + ' failed') 

        , duration
