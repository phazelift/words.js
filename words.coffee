# words.coffee - My Javascript word/string manipulation library, written in Coffeescript.
#
#		Experimental and under development, things will change, use with care.
#
#		Depends on my strings.js library
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

Strings= Str= _= require 'strings.js'

# call with context!
changeCase= ( method, args ) ->
	if _.isString args?[0] then @set Str[ method ] @$, args...		# strings
	else if (args?[0] is 0) then for pos in args							# words[indices]
		for index in [ 0..@count- 1 ]
			@words[ index ]= Str[ method ] @words[ index ], pos
	else
		args= [0..@count] if args.length < 1								# words
		for pos in args
			pos= _.positiveIndex pos, @count
			@words[ pos ]= Str[ method ] @words[ pos ]


delimiter= ' '
class Words extends Strings

	constructor: ->
		Object.defineProperty @, '$', { get: -> @.get() }
		Object.defineProperty @, 'string', { get: -> @.get() }
		Object.defineProperty @, 'count', { get: -> @words.length }
		@set.apply @, arguments

	set: ->
		return @ if arguments.length < 1
		@words= []
		for arg in arguments
			@words.push( str ) for str in Str.split Str.create(arg), delimiter
		return @

	get: ->
		return @words.join( delimiter ) if arguments.length < 1
		string= ''
		for index in arguments
			index= _.positiveIndex( index, @count )
			string+= @words[ index ]+ delimiter if index isnt false
		return Str.trim string

	xs: ( callback= -> true ) ->
		return if _.notFunction(callback) or @count < 1
		result= []
		for word, index in @words
			if response= callback( word, index )
				if response is true then result.push word
				else if _.isStringOrNumber response
					result.push response
		@words= result
		return @

	find: ( string, showPositions ) ->
		indices= []
		if '' isnt string= Str.force string
			@xs ( word, index ) ->
				for position in Str.find word, string
					if showPositions then indices.push [index+ 1, position]
					else indices.push index+ 1
		return indices

	applyToValidIndex: ( orgIndex, callback ) ->	callback( index ) if false isnt index= _.positiveIndex orgIndex, @count; @

	upper: -> changeCase.call @, 'upper', Array::slice.call arguments; @
	lower: -> changeCase.call @, 'lower', Array::slice.call arguments; @

	reverse: ->
		if arguments?[0] is 0 then @xs ( word ) -> Str.reverse word
		else if arguments.length > 0 then for arg in arguments
			@applyToValidIndex arg, ( index ) => @words[ index ]= Str.reverse @words[ index ]
		else @set Str.reverse @$
		return @

	shuffle: ( selection ) ->
		if selection?
			if _.isString( selection ) then for arg in arguments
				@xs ( word, index ) =>
					return Str.shuffle( word ) if word is arg
					return true
			else if selection is 0
				@xs ( word ) -> Str.shuffle word
			else for arg in arguments then @applyToValidIndex arg, ( index ) =>
				@words[ index ]= Str.shuffle @words[ index ]
		else @words= _.shuffleArray @words
		return @

	clear: -> @words= []; @

	remove: ->
		return @ if arguments.length < 1
		return @clear() if arguments?[0] is 0
		for arg in arguments
			if _.isString arg then @xs ( word ) -> true if word isnt arg
			else @xs ( word ) => true if word isnt @words[ _.positiveIndex arg, @count ]
		return @

	pop: ( amount= 1 ) -> @words.pop() for n in [ 1..amount ];	@

	push: ->
		for arg in arguments
			@words.push Str.trim( arg ) if _.isStringOrNumber arg
		return @

	shift: ( amount= 1 ) ->	@words.shift() for n in [1..amount]; @

	prepend: ->
		for arg in arguments
 			@words.unshift Str.trim( arg ) if _.isStringOrNumber arg
		return @

	insert: ( index, words... ) ->
		return @prepend( arguments... ) if _.isString index
		@words.splice( index, 0, Str.trim word )	for word in words
		return @

	replace: ( selection, replacement= '' ) ->
		return @ if '' is replacement= Str.trim replacement
		if _.isNumber selection
			@applyToValidIndex selection, ( index ) => @words.splice( index, 1, replacement )
		else @xs ( word ) ->
			return replacement if word is selection
			return true
		return @

Words::unshift= Words::prepend

return window.Words if window?
return module.exports= Words if module