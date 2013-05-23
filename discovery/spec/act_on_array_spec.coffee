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

    context 'arrays of tasks', (it) -> 


        it 'can resolve array in sequence', (done) -> 

            thing1 = new Thing 'one'
            thing2 = new Thing 'two'
            thing3 = new Thing 'three'
            thing4 = new Thing 'four'

            sequence( [

                -> nodefn.call( Thing.doo, thing1, 5 )
                -> nodefn.call( Thing.doo, thing2, 5 )
                -> nodefn.call( Thing.doo, thing3, 5 )
                -> nodefn.call( Thing.doo, thing4, 5 )

            ] ).then (results) -> 

                results.should.eql ['one', 'two', 'three', 'four']
                test done
            


        it 'can build task array in loop', (done) -> 

            things = [

                new Thing 'one'
                new Thing 'two'
                new Thing 'three'
                new Thing 'four'

            ]

            tasks = []

            for thing in things

                tasks.push -> nodefn.call( Thing.doo, thing, 5 )

            sequence( tasks ).then (results) -> 

                #
                # results.should.eql ['one', 'two', 'three', 'four']
                # 
                #   Operates on 4th thing 4 times... 
                # 
                #          Which makes sense: 
                # 
                #          The value of thing by the time the 
                #          calls are made is the last thing.
                # 

                test done


        it 'can process a task array in loop by poping a second targets array', (done) -> 

            things = [

                new Thing 'one'
                new Thing 'two'
                new Thing 'three'
                new Thing 'four'

            ]

            tasks   = []
            targets = []

            for thing in things

                targets.unshift thing
                tasks.push -> nodefn.call Thing.doo, targets.pop(), 5


            sequence( tasks ).then (results) -> 

                results.should.eql ['one', 'two', 'three', 'four']
                test done


        it 'can do the same again but build the array inline', (done) -> 

            things = [

                new Thing 'one'
                new Thing 'two'
                new Thing 'three'
                new Thing 'four'
                new Thing 'five'
                new Thing 'six'
                new Thing 'seven'
                new Thing 'eight'
                new Thing 'nine'
                new Thing 'ten'
                new Thing 'eleven'

            ]

            targets = []
            i       = 1000

            sequence( 

                for thing in things

                    targets.unshift thing                    # 
                                                             #  first task takes longest
                                                             #  (to ensure the sequence)
                                                             # 
                    -> nodefn.call Thing.doo, targets.pop(), i /= 1.5

            ).then (results) -> 

                results.should.eql [
                    'one'
                    'two'
                    'three'
                    'four'
                    'five'
                    'six'
                    'seven'
                    'eight'
                    'nine'
                    'ten'
                    'eleven'
                ]
                test done


        it 'stops on error', (done) -> 

            things = [

                new Thing 'one'     #
                new Thing 'two'     # these results are 'lost', or rather: 
                new Thing 'three'   # they are not sent to the success 
                new Thing 'four'    # callback
                new Thing 'five'    #
                new Thing 'six'
                new Thing 7         # <-------- causes error
                new Thing 'eight'   
                new Thing 'nine'    # 
                new Thing 'ten'     #   these dont run
                new Thing 'eleven'  # 

            ]

            targets = []
            
            sequence( for thing in things

                targets.unshift thing
                -> nodefn.call Thing.doo, targets.pop(), 5

            ).then(

                success = (results) -> 

                error = (reason) -> 
                    console.log 'ERROR--------->', reason
                    reason.should.match /far too numbersome/
                    test done

            )
           
           

