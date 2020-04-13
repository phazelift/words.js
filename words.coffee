#
# words.coffee - A Javascript word-string manipulation library, written in Coffeescript.
#
# MIT License
#
# Copyright (c) 2014 Dennis Raymondo van der Sluis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

"use strict"

Strings = _ = require "strings.js"
types = Strings.Types
Chars = Strings.Chars


class Words_

	@delimiter: ' '

	@stringsFromArray: ( array ) ->
		strings= []
		for value in _.forceArray array
			strings.push value if _.isString value
		return strings

	@numbersFromArray: ( array ) ->
		numbers= []
		for value in _.forceArray array
			numbers.push (value+ 0) if _.isNumber value
		return numbers

	# call with context!
	@changeCase: ( method, args ) ->
		words= Words_.stringsFromArray args
		indices= Words_.numbersFromArray args
		if words.length > 0 then @set Strings[ method ] @string, words...		# strings
		if indices[0] is 0 then for pos in indices									# words[indices] (characters)
			for index in [ 0..@count- 1 ]
				@words[ index ]= Strings[ method ] @words[ index ], pos
		else
			indices= [0..@count] if args.length < 1									# words
			for index in indices
				index= _.positiveIndex index, @count
				@words[ index ]= Strings[ method ] @words[ index ]

	@applyToValidIndex: ( orgIndex, limit, callback ) => callback( index ) if false isnt index= _.positiveIndex orgIndex, limit



class Words extends Strings

	constructor: ( args... ) ->
		super()
		@set.apply @, arguments


	set: ( args... ) ->
		@words= []
		args= _.intoArray.apply @, args
		return @ if args.length < 1
		for arg in args
			@words.push( str ) for str in Strings.split Strings.create(arg), Words_.delimiter
		return @

	get: ->
		return @words.join( Words_.delimiter ) if arguments.length < 1
		string= ''
		for index in arguments
			index= _.positiveIndex( index, @count )
			string+= @words[ index ]+ Words_.delimiter if index isnt false
		return Strings.trim string

	xs: ( callback= -> true ) ->
		return @ if _.notFunction(callback) or @count < 1
		result= []
		for word, index in @words
			if response= callback( word, index )
				if response is true then result.push word
				else if _.isStringOrNumber response
					result.push response+ ''
		@words= result
		return @

	find: ( string ) ->
		indices= []
		if '' isnt string= _.forceString string
			@xs ( word, index ) ->
				indices.push(index+ 1) if word is string
				return true
		return indices

	upper: -> Words_.changeCase.call @, 'upper', Array::slice.call arguments; @
	lower: -> Words_.changeCase.call @, 'lower', Array::slice.call arguments; @

	reverse: ->
		if arguments?[0] is 0 then @xs ( word ) -> Strings.reverse word
		else if arguments.length > 0 then for arg in arguments
			Words_.applyToValidIndex arg, @count, ( index ) => @words[ index ]= Strings.reverse @words[ index ]
		else @xs (word, index) => @get @count- index
		return @

	shuffle: ( selection ) ->
		if selection?
			if _.isString( selection ) then for arg in arguments
				@xs ( word, index ) =>
					return Strings.shuffle( word ) if word is arg
					return true
			else if selection is 0
				@xs ( word ) -> Strings.shuffle word
			else for arg in arguments then Words_.applyToValidIndex arg, @count, ( index ) =>
				@words[ index ]= Strings.shuffle @words[ index ]
		else @words= _.shuffleArray @words
		return @

	clear: -> @words= []; @

	remove: ->
		return @ if arguments.length < 1
		args= []
		for arg in arguments
			if _.isString arg
				args.unshift arg
			else if _.isNumber arg
				args.push Words.positiveIndex arg, @count
		args= _.noDupAndReverse _.insertSort args
		for arg, index in args
			if _.isNumber arg
				@xs ( word, index ) => true if index isnt arg
			else if _.isString arg then @xs ( word ) -> true if word isnt arg
		return @

	pop: ( amount ) ->
		amount= Math.abs _.forceNumber amount, 1
		popped= ''
		for n in [ 1..amount ]
			pop= @words.pop()
			popped= (pop+ ' '+ popped) if pop isnt undefined
		return popped.trim()

	push: ->
		for arg in arguments
			@words.push Strings.trim( arg ) if ('' isnt arg= _.forceString arg)
		return @

	shift: ( amount ) ->
		amount= _.forceNumber amount, 1
		@words.shift() for n in [1..amount]
		return @

	prepend: ->
		pos= 0
		for arg in arguments
			if '' isnt arg= _.forceString arg
				@words.splice( pos, 0, Strings.trim arg )
				pos++
		return @

	insert: ( index, words... ) ->
		index= _.positiveIndex index, @count
		pos= 0
		for word in words
			if '' isnt word= _.forceString word
				@words.splice( index+ pos, 0, Strings.trim word )
				pos++
		return @

	replace: ( selection, replacement= '' ) ->
		return @ if '' is replacement= Strings.trim replacement
		if _.isNumber selection
			Words_.applyToValidIndex selection, @count, ( index ) => @words.splice index, 1, replacement
		else @xs ( word ) ->
			return replacement if word is selection
			return true
		return @

	sort: -> _.insertSort @words; @

	# refactor these two later..
	startsWith: ( start ) ->
		return false if '' is start= _.forceString start
		result= true
		start= new Words start
		start.xs (word, index) =>
			result= false if word isnt @words[ index ]
		return result

	endsWith: ( end ) ->
		return false if '' is end= _.forceString end
		result= true
		count= 1
		end= new Words end
		for index in [end.count..1]
			result= false if ( end.get(index) isnt @words[@count- count++] )
		return result

Object.defineProperty Words::, '$', { get: -> @.get() }
Object.defineProperty Words::, 'string', { get: -> @.get() }
Object.defineProperty Words::, 'count', { get: -> @words.length }

Words::unshift		= Words::prepend

Words.flexArgs		= types.intoArray
Words.Strings		= Strings
Words.types			= types
Words.Chars			= Chars


if define? and ( 'function' is typeof define ) and define.amd
	define 'words', [], -> Words
else if window?
	window.Words	= Words
	window.types	= types
	window.Strings	= Strings
else if module?
	module.exports	= Words