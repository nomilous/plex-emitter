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


        that 'has a rejector', (done) -> 

            defer = When.defer()
            defer.promise.then(

                -> 
                -> test done

            )
            defer.reject()


        that 'receives error', (done) ->

            error = ''
            defer = When.defer()
            defer.promise.then(

                -> 
                -> error = arguments[0]

            )
            defer.reject new Error 'eeee'


            setTimeout -> 
                error.should.match /eeee/
                test done
            ,10

