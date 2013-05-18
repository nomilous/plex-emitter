require('nez').realize 'PlayWithWhen', (When, test, context, should) -> 

    context 'when.defer()', (that) ->

        deferred = When.defer()


        that 'has a promise and resolver and then() to handle', (done) ->

            deferred = When.defer()
            deferred.promise.then(

                (result) -> 

                    test done

                (error) -> 
                    console.log 'should not error...', error

            )

            deferred.resolve 1
            deferred.reject new Error '...because it already resolved'


        that 'does not let exceptions out??', (done) -> 

            threw    = false
            deferred = When.defer()
            deferred.promise.then(

                (result) -> 

                    throw new Error('success handler raisens are sent to next handler')

                (reason) -> 


            ).then(

                (result) -> 

                (error) -> 

                    throw new Error('but if there is no next handler - errors are silenced!')

            ).then(

                ->           # result
                -> test done # error

            )

            deferred.resolve 1

