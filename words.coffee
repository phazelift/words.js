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
#=====================================================================================================
#														types.coffee (types.js v1.5.0)

instanceOf	= ( type, value ) -> value instanceof type
typeOf		= ( value, type= 'object' ) -> typeof value is type

LITERALS=
	'Boolean'	: false
	'String'		: ''
	'Object'		: {}
	'Array'		: []
	'Function'	: ->
	'Number'		: do ->
		number= new Number
		number.void= true
		return number

TYPES=
	'Undefined'		: ( value ) -> value is undefined
	'Null'			: ( value ) -> value is null
	'Function'		: ( value ) -> typeOf value, 'function'
	'Boolean'		: ( value ) -> typeOf value, 'boolean'
	'String'			: ( value ) -> typeOf value, 'string'
	'Array'			: ( value ) -> typeOf(value) and instanceOf Array, value
	'RegExp'			: ( value ) -> typeOf(value) and instanceOf RegExp, value
	'Date'			: ( value ) -> typeOf(value) and instanceOf Date, value
	'Number'			: ( value ) -> typeOf(value, 'number') and (value is value) or ( typeOf(value) and instanceOf(Number, value) )
	'Object'			: ( value ) -> typeOf(value) and (value isnt null) and not instanceOf(Boolean, value) and not instanceOf(Number, value) and not instanceOf(Array, value) and not instanceOf(RegExp, value) and not instanceOf(Date, value)
	'NaN'				: ( value ) -> typeOf(value, 'number') and (value isnt value)
	'Defined'		: ( value ) -> value isnt undefined

TYPES.StringOrNumber= (value) -> TYPES.String(value) or TYPES.Number(value)

Types= _=
	parseIntBase: 10


createForce= ( type ) ->

	convertType= ( value ) ->
		switch type
			when 'Number' then return value if (_.isNumber value= parseInt value, _.parseIntBase) and not value.void
			when 'String' then return value+ '' if _.isStringOrNumber value
			else return value if Types[ 'is'+ type ] value

	return ( value, replacement ) ->

		return value if value? and undefined isnt value= convertType value
		return replacement if replacement? and undefined isnt replacement= convertType replacement
		return LITERALS[ type ]


testValues= ( predicate, breakState, values= [] ) ->
	return ( predicate is TYPES.Undefined ) if values.length < 1
	for value in values
		return breakState if predicate(value) is breakState
	return not breakState


breakIfEqual= true
do -> for name, predicate of TYPES then do ( name, predicate ) ->

	Types[ 'is'+ name ]	= predicate
	Types[ 'not'+ name ]	= ( value ) -> not predicate value
	Types[ 'has'+ name ]	= -> testValues predicate, breakIfEqual, arguments
	Types[ 'all'+ name ]	= -> testValues predicate, not breakIfEqual, arguments
	Types[ 'force'+ name ]= createForce name if name of LITERALS

Types.intoArray= ( args... ) ->
	if args.length < 2
		if _.isString args[ 0 ]
			args= args.join( '' ).replace( /^\s+|\s+$/g, '' ).replace( /\s+/g, ' ' ).split ' '
		else if _.isArray args[ 0 ]
			args= args[ 0 ]
	return args

Types.typeof= ( value ) ->
	for name, predicate of TYPES
		return name.toLowerCase() if predicate( value ) is true

#															end of types.coffee

#=====================================================================================================

#															strings.coffee (version 1.2.3)


# returns the amount of successful parseInt's on array
mapStringToNumber= ( array ) ->
	return 0 if _.notArray array
	for value, index in array
		nr= _.forceNumber value
		return index if nr.void
		array[ index ]= nr
	return array.length

#															_ (selection of tools.js)

class _ extends Types

	@inRange: ( nr, range ) ->
		return false if (_.isNaN nr= parseInt nr, 10) or (mapStringToNumber( range ) < 2)
		return (nr >= range[0]) and (nr <= range[1])

	@limitNumber= ( nr, range ) ->
		nr= _.forceNumber nr, 0
		return nr if mapStringToNumber( range ) < 2
		return range[0] if nr < range[0]
		return range[1] if nr > range[1]
		return nr

	@randomNumber: ( min, max ) ->
		return 0 if mapStringToNumber([min, max]) < 2
		return min if max < min
		max= (max- min)+ 1
		return Math.floor ( Math.random()* max )+ min

	@shuffleArray: ( array ) ->
		return [] if _.notArray(array) or array.length < 1
		length= array.length- 1
		for i in [length..0]
			rand= _.randomNumber 0, i
			temp= array[ i ]
			array[ i ]= array[ rand ]
			array[ rand ]= temp
		return array

	@positiveIndex: ( index, max ) ->
		return false if 0 is index= _.forceNumber index, 0
		max= Math.abs _.forceNumber max
		if Math.abs( index ) <= max
			return index- 1 if index > 0
			return max+ index
		return false

	@insertSort: ( array ) ->
		length= array.length- 1
		for index in [ 1..length ]
			current	= array[ index ]
			prev		= index- 1
			while (prev >= 0) && (array[ prev ] > current)
				array[ prev+1 ]= array[ prev ]
				--prev
			array[ +prev+1 ]= current
		return array

	# only for sorted arrays
	@noDupAndReverse: ( array ) ->
		length= array.length- 1
		newArr= []
		for index in [length..0]
			newArr.push array[ index ] if newArr[ newArr.length- 1 ] isnt array[ index ]
		return newArr

	# process arguments list to contain only positive indexes, sorted, reversed order, and duplicates removed
	@sortNoDupAndReverse: ( array, maxLength ) ->
		processed= []
		for value, index in array
			value= _.forceNumber value
			continue if value.void
			if value <= maxLength
				value= _.positiveIndex value, maxLength
			processed.push _.forceNumber value, 0
		return _.noDupAndReverse _.insertSort processed

#																	Chars (selection of chars.js)

class Chars extends _

	@ASCII_RANGE_UPPERCASE	: [65, 90]
	@ASCII_RANGE_LOWERCASE	: [97, 122]
	@ASCII_RANGE_NUMBERS		: [48, 57]
	@ASCII_RANGE_SPECIAL_1	: [32, 47]
	@ASCII_RANGE_SPECIAL_2	: [58, 64]
	@ASCII_RANGE_SPECIAL_3	: [91, 96]
	@ASCII_RANGE_SPECIAL_4	: [123, 126]
	@ASCII_RANGE_ALL			: [32, 126]

	@REGEXP_SPECIAL_CHARS: ['?', '\\', '[', ']', '(', ')', '*', '+', '.', '/', '|', '^', '$', '<', '>', '-', '&']

	@ascii: ( ordinal ) -> String.fromCharCode _.forceNumber ordinal
	@ordinal: ( char ) -> _.forceNumber _.forceString(char).charCodeAt(), 0

	@random: ( range ) ->
		range= _.forceArray range, Chars.ASCII_RANGE_ALL
		min= _.limitNumber( range[0], range )
		max= _.limitNumber( range[1], range )
		return Chars.ascii _.randomNumber min, max

# end of Chars

#																		Strings
class Strings_
# refactor this later, and get rid of the ..., arguments[n] are ~10 times faster.
	@changeCase: ( string= '', caseMethod, args... ) ->
		return string if '' is string= _.forceString string
		if (args.length < 1) or args[0] is undefined
			return string[ caseMethod ]()
		else if _.isNumber( args[0] ) then for arg in args
			pos= _.positiveIndex( arg, string.length )
			string= Strings.xs string, ( char, index ) ->
				return char[ caseMethod ]() if index is pos
				return char
		else if _.isString( args[0] ) then for arg in args
			string= Strings.replace string, arg, arg[ caseMethod ](), 'gi'
		return string

class Strings extends Chars

	@create: ->
		string= ''
		string+= _.forceString( arg ) for arg in arguments
		return string

	@get: ( string, positions... ) ->
		return '' if arguments.length < 2
		string	= _.forceString string
		length	= string.length
		result	= ''
		argsLength= arguments.length
		for pos in [1..argsLength]
			pos= _.positiveIndex arguments[pos], length
			result+= string[ pos ] if pos isnt false
		return result

	@sort: ( string ) ->
		string= _.forceString( string ).trim().split( '' )
		return _.insertSort( string ).join ''

	@random: ( amount, charSet ) ->
		amount= _.forceNumber amount, 1
		string= ''
		string+= Chars.random(charSet) for i in [1..amount]
		return string;

	@times: ( string, amount ) ->
		return '' if '' is string= _.forceString string
		amount= _.forceNumber amount, 1
		multi= ''
		multi+= string while amount-- > 0
		return multi

	@regEscape: ( string ) ->
		return string if '' is string= _.forceString string
		return Strings.xs string, ( char ) ->
			return '\\'+ char	if char in Chars.REGEXP_SPECIAL_CHARS
			return true

	@empty: ( string ) ->
		return false if _.notString(string) or (string.length > 0)
		return true

	@isAlpha: ( string ) ->
		return false if '' is string= _.forceString string
		/^[a-z]*$/ig.test string

	@isNumeric: ( string ) ->
		return false if '' is string= _.forceString string
		/^[0-9]*$/g.test string

	@isAlphaNumeric: ( string ) ->
		return false if '' is string= _.forceString string
		/^[0-9|a-z]*$/ig.test string

	@isSpecial: ( string ) ->
		return false if '' is string= _.forceString string
		/^[^0-9|a-z]*$/ig.test string

	@isSpace: ( string ) -> /^[ \t]+$/g.test string

	@hasUpper: ( string ) -> /[A-Z]+/g.test string
	@isUpper: ( string ) -> /^[A-Z]+$/g.test string
	@isLower: ( string ) -> /^[a-z]+$/g.test string

	@xs: ( string= '', callback ) ->
		string= _.forceString string
		return '' if -1 is length= string.length- 1
		callback	= _.forceFunction callback, (char) -> char
		result= ''
		for index in [0..length]
			if response= callback( string[index], index )
				if response is true then result+= string[ index ]
				else if _.isStringOrNumber response
					result+= response
		return result

	@copy: ( string, offset, amount ) ->
		offset= _.forceNumber offset
		return '' if ( '' is string= _.forceString string ) or ( Math.abs(offset) > string.length )
		offset-= 1 if offset > 0
		return string.substr offset, _.forceNumber amount, string.length

	@replace: ( string= '', toReplace= '', replacement= '', flags= 'g' ) ->
		if not ( _.isStringOrNumber(string) and (_.typeof(toReplace) in [ 'string', 'number', 'regexp' ]) )
			return _.forceString string
		if _.notRegExp toReplace
			toReplace= Strings.regEscape (toReplace+ '')
			toReplace= new RegExp toReplace, flags	# check if needed -> _.forceString flags
		return (string+ '').replace toReplace, replacement

	@trim: ( string ) -> Strings.replace string, /^\s+|\s+$/g

	@trimLeft: ( string ) -> Strings.replace string, /^\s+/g

	@trimRight: ( string ) -> Strings.replace string, /\s+$/g

	@oneSpace: ( string ) -> Strings.replace string, /\s+/g, ' '

	@oneSpaceAndTrim: ( string ) -> Strings.oneSpace( Strings.trim(string) )

	@toCamel: ( string, char ) ->
		string= _.forceString string
		char	= _.forceString char, '-'
		match	= new RegExp( Strings.regEscape( char )+ '([a-z])', 'ig' )
		Strings.replace string, match, (all, found) -> found.toUpperCase()

	@unCamel: ( string, insertion ) ->
		string	= _.forceString string
		insertion= _.forceString insertion, '-'
		return Strings.replace( string, /([A-Z])/g, insertion+ '$1' ).toLowerCase()

	@shuffle: ( string ) ->
		string= _.forceString string
		return _.shuffleArray( (string+ '').split '' ).join('')

	@find: ( string, toFind, flags ) ->
		indices= []
		return indices if '' is string= _.forceString string
		flags= _.forceString flags, 'g'
		if _.isStringOrNumber toFind
			toFind= new RegExp Strings.regEscape(toFind+ ''), flags
		else if _.isRegExp toFind
			toFind= new RegExp toFind.source, flags
		else return indices
		# check for global flag, without it a while/exec will hang the system..
		if toFind.global
			indices.push( result.index+ 1 ) while result= toFind.exec string
		else
			indices.push( result.index+ 1 ) if result= toFind.exec string
		return indices

	@count: ( string, toFind ) -> Strings.find( string, toFind ).length

	@contains: ( string, substring ) -> Strings.count( string, substring ) > 0

	@between: ( string, before, after ) ->
		return '' if not _.allStringOrNumber string, before, after
		before= Strings.regEscape before+ ''
		after	= Strings.regEscape after+ ''
		reg	= new RegExp before+ '(.+)'+ after
		return reg.exec( string+ '' )?[1] or ''

	@slice: ( string, start, size ) ->
		string= _.forceString string
		start	= _.forceNumber (start or 1)
		if false isnt start= _.positiveIndex start, string.length
			size= _.forceNumber size
			return string.slice start, start+ size
		return ''

	@truncate= ( string, length, appendix ) ->
		string= _.forceString string
		length= _.forceNumber length, string.length
		string= Strings.slice string, 1, length
		return string+ _.forceString appendix

	@pop: ( string, amount ) ->
		string= _.forceString string
		amount= _.forceNumber amount, 1
		return string.slice 0, -Math.abs amount

	@split: ( string, delimiter ) ->
		string= Strings.oneSpaceAndTrim string
		result= []
		return result if string.length < 1
		delimiter= _.forceString delimiter, ' '
		array= string.split delimiter[0] or ''
		for word in array
			continue if word.match /^\s$/
			result.push Strings.trim word
		return result

	@reverse: ( string= '' ) ->
		string= _.forceString string
		return string if (length= string.length- 1) < 1
		reversed= ''
		reversed+= string[ ch ] for ch in [length..0]
		return reversed

	@upper: ( string, args... ) -> Strings_.changeCase string, 'toUpperCase', args...

	@lower: ( string, args...) -> Strings_.changeCase string, 'toLowerCase', args...

	@insert: ( string, insertion, positions... ) ->
		return string if ('' is string= _.forceString string) or ('' is insertion= _.forceString insertion)
		positions= _.sortNoDupAndReverse positions, string.length
		posCount= mapStringToNumber( positions )- 1
		return string if 0 > posCount
		for index in [0..posCount]
			index= positions[ index ]
			if index > string.length
				string= ( string+ insertion )
				continue
			string= string.substr( 0, index )+ insertion+ string.substr index
		return string

	@removeRange: ( string, offset, amount ) ->
		string= _.forceString string
		return string if ( string is '' ) or
			( false is offset= _.positiveIndex offset, string.length )	or
			( 0 > amount= _.forceNumber amount, 1 )
		endpoint= offset+ amount
		return Strings.xs string, ( char, index ) ->
			true if (index < offset) or (index >= endpoint)

	@removePos: ( string, positions... ) ->
		return '' if '' is string= _.forceString string
		pos= positions.map ( value, index ) -> _.positiveIndex value, string.length
		return Strings.xs string, ( char, index ) -> true if not ( index in pos )

	@remove: ( string= '', toRemove... ) ->
		return string if ('' is string= _.forceString string) or (toRemove.length < 1)
		string= Strings.replace( string, remove ) for remove in toRemove
		return string

	@startsWith: ( string, start ) ->
		return false if ('' is string= _.forceString string) or ('' is start= _.forceString start)
		start= new RegExp '^'+ Strings.regEscape start
		start.test string

	@endsWith: ( string, ending ) ->
		return false if ('' is string= _.forceString string) or ('' is ending= _.forceString ending)
		ending= new RegExp Strings.regEscape( ending )+ '$'
		return ending.test string

# test below this line:
	@wrap: ( prepend= '', append= '' ) ->
		wrapper= ( string ) -> Strings.create prepend, string, append
		wrapper.wrap= ( outerPrepend= '', outerAppend= '' ) ->
			prepend= _.forceString( outerPrepend )+ prepend
			append+= _.forceString( outerAppend )
		return wrapper


	constructor: ->
		@set.apply @, arguments
		@wrapMethod= null
		@crop= @slice

	set: -> @string= Strings.create.apply @, arguments; @

	sort: -> @string= Strings.sort @string; @

	random: ( amount, charSet ) -> @string= Strings.random amount, charSet; @

	xs: ( callback ) -> @string= Strings.xs @string, callback; @

	times: ( times= 1 ) -> @string= Strings.times @string, times; @

	get: ->
		if arguments.length > 0
			string= ''
			for position in arguments
				position= _.positiveIndex position, @length
				string+= @string[ position ] if position isnt false
			return string
		return @string

	copy: ( offset, amount ) -> Strings.copy @string, offset, amount

	empty: -> Strings.empty @string

	isAlpha: -> Strings.isAlpha @string
	isNumeric: -> Strings.isNumeric @string
	isAlphaNumeric: -> Strings.isAlphaNumeric @string
	isSpecial: -> Strings.isSpecial @string
	isSpace: -> Strings.isSpace @string
	isUpper: -> Strings.isUpper @string
	hasUpper: -> Strings.hasUpper @string
	isLower: -> Strings.isLower @string

	push: ->	@string= @string+ Strings.create.apply @, arguments; @

	prepend: -> @string= Strings.create.apply( @, arguments )+ @string; @

	pop: ( amount ) -> @string= Strings.pop @string, amount; @

	insert: ( string, positions... ) -> @string= Strings.insert @string, string, positions...; @

	trim: ->	@string= Strings.trim( @string ); @

	trimLeft: -> @string= Strings.trimLeft( @string ); @

	trimRight: -> @string= Strings.trimRight( @string ); @

	oneSpace: -> @string= Strings.oneSpace( @string ); @

	oneSpaceAndTrim: -> @string= Strings.oneSpaceAndTrim( @string ); @

	find: ( string ) -> Strings.find @string, string

	count: ( string ) -> Strings.count @string, string

	contains: ( string ) -> Strings.contains @string, string

	between: ( before, after ) -> Strings.between @string, before, after

	slice: ( start, size ) -> @string= Strings.slice @string, start, size; @

	truncate: ( size, suffix ) -> @string= Strings.truncate @string, size, suffix; @

	remove: ( strings... ) -> @string= Strings.remove @string, strings...; @

	removeRange: ( offset, amount ) -> @string= Strings.removeRange( @string, offset, amount ); @

	removePos: ( positions... ) -> @string= Strings.removePos @string, positions...; @

	replace: ( subString, replacement, flags ) -> @string= Strings.replace( @string, subString, replacement, flags ); @

	reverse: -> @string= Strings.reverse @string; @

	upper: ( args... ) -> @string= Strings.upper @string, args...; @

	lower: ( args... ) -> @string= Strings.lower @string, args...; @

	shuffle: -> @string= Strings.shuffle @string; @

	toCamel: ( char ) -> @string= Strings.toCamel @string, char; @

	unCamel: ( insertion ) -> @string= Strings.unCamel @string, insertion; @

	startsWith: ( start ) -> Strings.startsWith @string, start

	endsWith: ( ending ) -> Strings.endsWith @string, ending

	setWrap: ( prepend, append ) ->
		if _.isNull @wrapMethod then @wrapMethod= Strings.wrap prepend, append
		else @wrapMethod.wrap prepend, append
		return @

	removeWrap: -> @wrapMethod= null; @

	applyWrap: ( prepend, append ) ->
		@string= @setWrap( prepend, append ).wrap
		@removeWrap()
		return @

Object.defineProperty Strings::, '$', { get: -> @.get() }
Object.defineProperty Strings::, 'length', { get: -> @string.length }
Object.defineProperty Strings::, 'wrap',
	get: ->
		return @wrapMethod @string	if not _.isNull @wrapMethod
		return @string

# aliases:
Strings.Types= Types
Strings.Chars= Chars
Strings.crop= Strings.slice
Strings::crop= Strings::slice
Strings::append= Strings::push

#																end of Strings

#=====================================================================================================

#																Words

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

	constructor: -> @set.apply @, arguments

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

Words::unshift= Words::prepend

Words.flexArgs= Types.intoArray

Words.Strings	= Strings
Words.Types		= Types
Words.Chars		= Chars


if define? and ( 'function' is typeof define ) and define.amd
	define 'words', [], -> Words
else if window?
	window.Words	= Words
	window.Types	= Types
	window.Strings	= Strings
else if module?
	module.exports	= Words