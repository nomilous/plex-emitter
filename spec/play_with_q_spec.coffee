require('nez').realize 'PlayWithQ', (PlayWithQ, test, context, q) -> 

    context 'q.fcall()', (it) -> 

        it 'pends a function for a future resolution (via then())', (done) ->

            i = 0
            pend = q.fcall -> ++i
            i.should.equal 0

            pend.then (result) -> 
                result.should.equal 1
                test done

        it """will only ever resolve the function once, 
              but the result will remain available""", (done) -> 

            i = 0
            pend = q.fcall -> ++i

            pend.then (result) -> result.should.equal 1
            pend.then (result) -> result.should.equal 1
            pend.then (result) -> result.should.equal 1
            pend.then (result) -> test done


        it 'is chainable', (done) -> 

            i = 0
            pend = q.fcall( -> i++ ).then( -> i++ ).then( -> i++ )
            i.should.equal 0

            pend.then (result) -> 
                i.should.equal 3
                test done

    context 'q.defer()', (it) -> 

        it 'creates a promise / resolve pair', (done) -> 

            deferred = q.defer()

            i = 0
            deferred.promise.then (result) -> 
                if result == 2 then throw 'RAN RESOLVER TWICE'

            setTimeout -> 
                test done
            , 500 

            deferred.resolve 1
            deferred.resolve 2


        it 'can create an async function', (done) -> 

            doThing = -> 

                deferred = q.defer()

                #
                # long running process calls resolve 
                #

                setTimeout -> 
                    deferred.resolve 1
                , 500

                #
                # return the promise
                #

                return deferred.promise


            doThing().then (result) -> 

                result.should.equal 1
                test done


