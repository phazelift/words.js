words.js
========

words.js is all about finding/manipulating/sorting/adding/removing words in or from a string.
<br/>
<br/>
words.js extends strings.js. Most methods overload strings.js methods, only to focus on words rather than characters.
Where in strings.js you use shuffle to randomly reorder the characters in a string, in words.js the overloaded
shuffle function randomly reorders the words in a string. This same idea applies to pretty much all methods of
words.js, although some methods like .upper() and .lower(), combine word and character based manipulation.
<br/><br/>

___
You can use `npm install words.js` when using node.js. The dependant strings.js and included types.js will
automatically be installed as well.
<br/>
<br/>
Use:
```javascript
var Types= Words.Types
var Strings= Words.Strings
// or
var Types= require('words.js').Types;
var Strings= require('words.js').Strings;
```
to have the non-overloaded strings.js, but also the handy types.js functions available as well.
___

types.js, strings.js and words.js are a very powerful set of building blocks that can make the life of a Javascript
developer much more pleasant and bug free IMHO.
<br/>

All examples are to be found in the API below.
___
API
---

**Words.prototype.constructor**
> `<this> constructor( <string>/<number> string= '' )`

> Initializes the contextual object.

> Use any combination of arguments to form a string. All invalid arguments will be ignored.

```javascript
var words= new Words('numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..');
// numbers accepted 123 not objects, arrays etc.. they are simply ignored..
```

**Words.prototype.set**
> `<string> set( <string>/<number> index, [index1, ..., indexN] )`

> Set the internal array. Use any combination of arguments to form a string. All
> invalid arguments will be ignored.

```javascript
var words= new Words();
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
// numbers accepted 123 not objects, arrays etc.. they are simply ignored..
```

**Words.prototype.get**
> `<string> get( <string>/<number> index, [index1, ..., indexN] )`

> Returns the word(s) found at index(es).

```javascript
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
words.get( 1, 2, 6, -1 );
// numbers accepted arrays ignored..
```

**Words.prototype.xs**
> `<this> xs( <function> callback(<string> word, <number> index) )`

> Access every index/word of the internal array and apply the result of callback to it. After a call to xs, the
> internal array will be changed to the results of the callback.

> If the callback returns true, word is applied, but you could also return word which has effectively the same result.
> If the callback returns false or undefined, word will be skipped. Any character, String or Number returned by callback
> will be applied to index in the internal array.

```javascript
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
var max3= words.xs( function(word, index){
	return true if word.length < 4 ).$;
});
// 123 not are

var max3= words.xs( function(word, index){
	if( word === '123' )
		return '*'+ word+ '*'
	else return true
});
// numbers accepted *123* not objects, arrays etc.. they are simply ignored..
```

**Words.prototype.find**
> `<array> find( <string>/<number> substring )`

> Returns an array containing all indices(numbers) in the internal array where substring is found.

```javascript
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
words.find( 'hello' );
// []
words.find( 'accepted' );
// [2]
```

**Words.prototype.upper**
> `<this> upper( <string>/<number> index, <string>/<number> position )`

> Change words or characters in words to uppercase. If no arguments are given, all words are changed to uppercase.
> If index is set to 0, all character positions denoted by position, in all words, are changed to uppercase
> (if alpha of course). If indices is not set to 0, the words found on indices are changed to uppercase.

```javascript
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.upper(0, 1, -1).$ );
// NumberS AccepteD 123 NoT Objects, ArrayS Etc.. TheY ArE SimplY Ignored..
console.log( words.upper(1, 4, -1).$ );
// note that the internal array is changed and we are applying a upper over it:
// NUMBERS AccepteD 123 NOT Objects, ArrayS Etc.. TheY ArE SimplY IGNORED..
console.log( words.upper().$ );
// NUMBERS ACCEPTED 123 NOT OBJECTS, ARRAYS ETC.. THEY ARE SIMPLY IGNORED..
```

**Words.prototype.lower**
> `<this> lower( <string>/<number> index, <string>/<number> position )`

> The same as with .upper(), except for that uppercase characters are changed to lowercase.

**Words.prototype.reverse**
> `<this> reverse( <string>/<number> index, [index1, ..., indexN] )`

> Without arguments the whole internal array(as string) is reversed. With index or indices given, the words denoted by
> indices are reversed. If index is 0, every word is reversed, but will remain on it's original/current index,
> every additional argument is ignored.

```javascript
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.reverse().$ );
//..derongi ylpmis era yeht ..cte syarra ,stcejbo ton 321 detpecca srebmun

words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.reverse(0).$ );
// srebmun detpecca 321 ton ,stcejbo syarra ..cte yeht era ylpmis ..derongi

words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.reverse(1, 3, -2).$ );
// srebmun accepted 321 not objects, arrays etc.. they are ylpmis ignored..
```

**Words.prototype.shuffle**
> `<this> shuffle( <string>/<number> index, [index1, ..., indexN] )`

> Shuffles the word on index, if index is given. If index is/are strings, the matching words will be shuffled.
> If index is 0, every word is shuffled, but will remain on it's current index, following arguments are ignored.
> Without arguments, all indices are shuffled.

```javascript
words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.shuffle().$ );
// without arguments all words positions are pseudo randomly shuffled:
// they numbers accepted not objects, etc.. ignored.. arrays are simply 123


words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.reverse(0).$ );
// with 0, characters in words are pseudo randomly shuffled in place, below a run on my system:
//brmneus ptcdeace 231 tno e,bsctjo raaysr .et.c yteh ear ilmyps .ro.engdi


words.set( 'numbers accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.reverse(1, 3, -1).$ );
// characters in words on indices are pseudo randomly shuffled:
//rubmsne accepted 312 not objects, arrays etc.. they are simply d.eirno.g
```

**Words.prototype.clear**
> `<this> clear()`

> Resets the internal array to empty [].

**Words.prototype.remove**
> `<this> remove( <string>/<number> indices and or words )`

> Removes any combination of indices or words from the internal array. Without arguments remove does nothing.
> Invalid arguments are ignored

```javascript
var words= new Words( 'testing words is real fun, actually for real!' );
console.log( words.remove( null, 'real', -1, {}, 4, 5, new Date(), -2, 'is', []) );
// testing words actually
```

**Words.prototype.pop**
> `pop( <string>/<number> amount )`

> Removes the last word from the internal array if no arguments are given. If amount is valid, amount words will
> be removed from the internal array, starting from the last word going backwards.

```javascript
var words= new Words( 'testing words is real fun!' );
console.log( words.pop(3) );
// testing words
```

**Words.prototype.push**
> `push( <string>/<number> word, [word1, ..., wordN] )`

> Adds words to the end of the internal array.

```javascript
var words= new Words( 'testing words' );
console.log( words.push( 'before', 'usage' ).$ );
// testing words before usage
```

**Words.prototype.shift**
> `shift( <string>/<number> amount )`


> Removes the first word from the internal array if no arguments are given. If amount is valid, amount words will
> be removed from the internal array, starting from the first word going forwards.

```javascript
var words= new Words( 'serious testing of words is fun!' );
console.log( words.shift(3).$ );
// words is fun!
```

**Words.prototype.unshift**
> `unshift( <string>/<number> word, [word1, ..., wordN]  )`

> Adds words to the beginning of the internal array.

```javascript
var words= new Words( 'words is fun!' );
console.log( words.unshift('of', 'testing', 'serious').$ );
// serious testing of words is fun!
```

**Words.prototype.insert**
> `insert( <string>/<number> index, <string>/<number> word, [word1, ..., wordN]  )`

> Insert word(s) at index of the internal array.

```javascript
var words= new Words( 'testing words' );
console.log( words.insert( -1, 'some', 'silly' ).$ );
// testing some silly words
```

**Words.prototype.replace**
> `replace( <string>/<number> selection, <string>/<number> replacement )`

> Replace all words equal to selection to replacement.

```javascript
var words= new Words( 'to replace or not to replace' );
console.log( words.replace('replace', 'be').$ );
// to be or not to be
```


**Words.prototype.sort**
> `<this> sort()`

> Sorts the internal array alphabetically

```javascript
var words= new Words( 'testing words is really funny actually' );
console.log( words.sort().$ );
// actually funny is really testing words
```

__________

change log
==========

**0.1.2**

words.js now depends on strings.js version 1.1.4.. strings.js now includes types.js version 1.2.8, which is
improved with force'Type'. Check types.js in the phazelift repo for changes and API.

Words.prototype.find only finds words now, use Strings.find for finding characters in words.
Words.prototype.remove(0) has been removed as an option to clear the internal array. Not a big thing, I just thought
that we have .clear() for that, so it felt a bit confusing and redundant.

The manual is now more complete and up to date.

Next up are the Jasmine tests!

__________


