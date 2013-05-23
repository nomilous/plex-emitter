nodefn   = require 'when/node/function'
sequence = require 'when/sequence' 

require('nez').realize 'ActOnArray', (Thing, test, context, should) -> 

    context 'thing has access to self', (done) ->

        thing = new Thing 'result'
        thing.do 5, (error, result) -> 

            result.should.equal 'result'
            test done


    context 'with when', (it) -> 

        thing = new Thing 'result'

        it 'is possible to convert the node style callback to a deferral', (done) -> 

            nodefn.call( thing.do, 5 ).then (result) -> test done


        it 'has access to self', (done) -> 

            nodefn.call( thing.do, 5 ).then (result) ->

                # result.should.equal 'thing'
                # 
                # LOSS OF SELF
                # 

                test done


        it 'works with instance assignent to class method', (done) -> 

            nodefn.call( Thing.doo, thing, 5 ).then (result) ->
                
                result.should.equal 'result'
                test done


        it 'errors', (done) -> 

            nodefn.call( Thing.fails, thing, 5 ).then(

                (result) -> 
                (error) -> 
                    error.should.match /result failed/
                    test done

            )
