require('nez').realize 'PlayWithWhen', (When, test, context, should) -> 

    context 'when.defer()', (it) ->

        deferred = When.defer()


        it 'has a promise and resolver and then() to handle', (done) ->

            deferred = When.defer()
            deferred.promise.then(

                (result) -> 

                    test done

                (error) -> 
                    console.log 'should not error...', error

            )

            deferred.resolve 1
            deferred.reject new Error '...because it already resolved'


        it 'does not let exceptions out??', (done) -> 

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


        it 'has a rejector', (done) -> 

            defer = When.defer()
            defer.promise.then(

                -> 
                -> test done

            )
            defer.reject()


        it 'receives error', (done) ->

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



        it 'can be constructed into a promise function', (done) ->

            doSomething = -> 
                defer = When.defer()
                setTimeout -> 
                    #
                    # long running thing
                    #
                    #defer.reject( new Error 'error' ) 
                    defer.notify 'status'
                    defer.resolve 'result'

                , 1000
                return defer.promise

            doSomething().then(

                success = (result) -> test done
                error   = (reason) -> 
                notify  = (status) -> 

            )

        it 'can notify of progress', (done) -> 

            doSomething  = -> 
                defer    = When.defer()
                setTimeout( 
                    -> defer.notify '50%'
                    10
                )
                setTimeout( 
                    -> defer.notify '75%'
                    20
                )
                setTimeout(
                    -> defer.notify '99%'
                    30
                )
                setTimeout(
                    -> defer.resolve 'result'
                    40
                )
                defer.promise


            doSomething().then(

                -> test done
                -> #error
                (progress) -> console.log progress

            )


