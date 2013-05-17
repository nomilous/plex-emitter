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


        it 'is chainable', (done) -> 

            i = 0
            pend = q.fcall( -> i++ ).then( -> i++ ).then( -> i++ )
            i.should.equal 0

            pend.then (result) -> 
                i.should.equal 3
                test done
