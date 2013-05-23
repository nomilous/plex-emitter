module.exports = class Thing

    constructor: (@result) -> 

    do: (duration, callback) -> 

        setTimeout =>

            callback null, @result 

        , duration

