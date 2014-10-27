# words.coffee - A Javascript word-string manipulation library, written in Coffeescript.
#
# Depends on strings.js (https://github.com/phazelift/strings.js.git).
#
# Copyright (c) 2014 Dennis Raymondo van der Sluis
#
# This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>

"use strict"

# load dependencies
if window? then Strings= window.Strings
else if module? then Strings= require 'strings.js'

_= Strings

stringsFromArray= ( array ) ->
	strings= []
	for value in _.forceArray array
		strings.push value if _.isString value
	return strings

numbersFromArray= ( array ) ->
	numbers= []
	for value in _.forceArray array
		numbers.push (value+ 0) if _.isNumber value
	return numbers

# call with context!
changeCase= ( method, args ) ->
	words= stringsFromArray args
	indices= numbersFromArray args
	if words.length > 0 then @set Strings[ method ] @string, words...		# strings
	if indices[0] is 0 then for pos in indices									# words[indices] (characters)
		for index in [ 0..@count- 1 ]
			@words[ index ]= Strings[ method ] @words[ index ], pos
	else
		indices= [0..@count] if args.length < 1									# words
		for index in indices
			index= _.positiveIndex index, @count
			@words[ index ]= Strings[ method ] @words[ index ]

applyToValidIndex= ( orgIndex, limit, callback ) => callback( index ) if false isnt index= _.positiveIndex orgIndex, limit

delimiter= ' '
class Words extends Strings

	constructor: -> @set.apply @, arguments

	set: ->
		@words= []
		return @ if arguments.length < 1
		for arg in arguments
			@words.push( str ) for str in Strings.split Strings.create(arg), delimiter
		return @

	get: ->
		return @words.join( delimiter ) if arguments.length < 1
		string= ''
		for index in arguments
			index= _.positiveIndex( index, @count )
			string+= @words[ index ]+ delimiter if index isnt false
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

	upper: -> changeCase.call @, 'upper', Array::slice.call arguments; @
	lower: -> changeCase.call @, 'lower', Array::slice.call arguments; @

	reverse: ->
		if arguments?[0] is 0 then @xs ( word ) -> Strings.reverse word
		else if arguments.length > 0 then for arg in arguments
			applyToValidIndex arg, @count, ( index ) => @words[ index ]= Strings.reverse @words[ index ]
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
			else for arg in arguments then applyToValidIndex arg, @count, ( index ) =>
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
		amount= Math.abs( _.forceNumber amount, 1 )
		@words.pop() for n in [ 1..amount ]
		return @

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
			applyToValidIndex selection, @count, ( index ) => @words.splice index, 1, replacement
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

Words::unshift= Words::prepend
Words.Strings= Strings
Words.Types	= Strings.Types
Words.Chars = Strings.Chars

return window.Words= Words if window?
return module.exports= Words if module?