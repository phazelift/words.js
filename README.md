words.js
========

**words.js** is a library/toolbox for working with strings and words. Great for handling command-line or text input, educational tools, word-games, text filters, password generators, etc..
<br/>
___

**a few quick examples:**
```javascript
import Words from 'words.js';

const words = new Words('pick the words you need with indices');

console.log( words.get(1, 3, -2, 3) );
// pick words with words

words.set('you can be very specific with upper and lowercase')
	.upper(-1, -3, 'y', 'specific')
console.log( words.$ );
// You can be verY SPECIFIC with UPPER and LOWERCASE

words.set('you can reverse all word positions').upper(-1, 3).reverse();
console.log( words.$ );
// POSITIONS word all REVERSE can you

words.set('or reverse or remove specific words and sort?')
	.reverse(2, -1).remove('or', 'remove').sort();
console.log( words.$ );
// ?tros and esrever specific words

words.set('noticed you can remove indices and words mixed?')
	.remove('noticed', -2, -4, 'and');
console.log( words.$ );
// you can remove mixed?

words.set('or shuffle specific words').shuffle(2, 3);
console.log( words.$ );
// or seuhlff fiiespcc words (pseudo random)

words.set('.startsWith searches for matching complete words');
console.log( words.startsWith('.startsWith search') );
// false
console.log( words.startsWith('.startsWith searches') );
// true

// more examples below in the API
```
___

**Dependencies and loading**

words.js depends on strings.js.

- strings.js is a flexible string manipulation library. It's API can be found at: https://github.com/phazelift/strings.js

___

Most methods overload strings.js methods, only to focus on words rather than characters.
Where in strings.js you use shuffle to randomly reorder the characters in a string, in words.js the overloaded shuffle function randomly reorders the words in a string, or you can shuffle the characters of a specific word in a string, and much more. See the API for examples.
<br/><br/>
All indexes in words.js are 1 based. Negative indexes can be used in most functions. -1 references the last word in the internal words array, 1 references the first word.

words.js is made for chaining operations on words in strings, most of it's methods return their
own context. To return the actual value of the internal string/array, one can use `.get()` or `.$` or `.string`.
___
All input and output is type save; you can throw in any type and still get a string if the expected output is of type `<string>`. If any method receives an argument of a type it cannot process, the argument will simply be ignored.

___
API
---

If you see `<string>/<number>`, it means you can either enter a String or Number argument, both will be parsed correctly.
___

**Words.prototype.words**
> `<array> words`

> The internal array were all (space seperated) words are stored. Better not use directly to avoid bugs, instead use .set() to set, and .get(), .$ and .string to fetch.

**Words.prototype.constructor**
> `<this> constructor( <string>/<number> string= '' )`

> Initializes the contextual object.

> Use any combination of arguments to form a string. All invalid arguments will be ignored.

```javascript
var words= new Words('numbers and strings accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..');
console.log( words.$ );
// numbers and strings accepted 123 not objects, arrays etc.. they are simply ignored..
```

**Words.prototype.count**
> `<number> count`

> A getter to get the amount of words in this.words.

```javascript
var words= new Words('word counting included');
console.log( words.count );
// 3
```

**Words.prototype.set**
> `<this> set( <string> string1, ..., stringN )`

> Set this.words with string(s). The strings can be given in the 3 (types.js) .intoArray forms, see .intoArray description in types.js.

> Use any combination of arguments to form a string. All invalid arguments will be ignored.

```javascript
var words= new Words();
words.set( 'numbers and strings accepted', 123, 'not objects, arrays etc..', {}, [1,2,3], 'they are simply ignored..' );
console.log( words.$ );
// numbers and strings accepted 123 not objects, arrays etc.. they are simply ignored..
```

**Words.prototype.get**
> `<string> get( <string>/<number> index, [index1, ..., indexN] )`

> Returns the word(s) found at index(es).

```javascript
var words= new Words('we can be very specific and pick any word we need');
console.log( words.get(5, -1) );
// specific need
```
**Words.prototype.$**
> `<string> $`

> A getter for .get()

```javascript
var words= new Words('fetch the whole string with a getter');
console.log( words.$ );
// fetch the whole string with a getter
```

**Words.prototype.string**
> `<string> string`

> Another getter for .get(), similar to .$.

**Words.prototype.xs**
> `<this> xs( <function> callback(<string> word, <number> index) )`

> Access every index/word of this.words and apply the result of callback to it. After a call to xs, this.words will be changed to the results of the callback.

> If the callback returns true, word is applied, but you could also return word which has effectively the same result. If the callback returns false or undefined, word will be skipped. Any character, String or Number returned by callback will be applied to index in this.words.

```javascript
// dispose all words longer than 4 characters
var words= new Words('words of more than 4 characters will be removed');
words.xs( function(word, index){
  if( word.length < 5 )
    return true;
});
console.log( words.$ );
// of more than 4 will be
```

**Words.prototype.find**
> `<array> find( <string>/<number> substring )`

> Returns an array containing all indices(numbers) in this.words where substring is found.

```javascript
var words= new Words('finding words with words is easy!');
console.log( words.find('words') );
// [2, 4]
```

**Words.prototype.upper**
> `<this> upper( <string>/<number> value, [value1, ..., valueN] )`

> Change words or characters to uppercase. If no arguments are given, all words are changed to uppercase. If index is set to 0, all character positions denoted by position, in all words, are changed to uppercase (if alpha of course). If indices is not set to 0, the words found on indices are changed to uppercase. valueN can also be a word, and words can be mixed with indices.

```javascript
var words= new Words('you can be very specific with upper and lowercase');
console.log( words.upper(-1, -3, 'y', 'specific').$ );
// You can be verY SPECIFIC with UPPER and LOWERCASE

var words= new Words('you can be very specific with upper and lowercase');
console.log( words.upper(0, 1, -1).$ );
// YoU CaN BE VerY SpecifiC WitH UppeR AnD LowercasE

var words= new Words('shout it all out!');
console.log( words.upper().$ );
// SHOUT IT ALL OUT!
```

**Words.prototype.lower**
> `<this> lower( <string>/<number> value, [value1, ..., valueN] )`

> The same as with .upper(), except for that uppercase characters are changed to lowercase.

**Words.prototype.reverse**
> `<this> reverse( <string>/<number> index, [index1, ..., indexN] )`

> Without arguments this.words is reversed; not the characters, like with Strings.reverse(), but the words positions in this.words are reversed. If index is 0, every word is reversed, but will remain on it's original/current index, every additional argument is then ignored. With index or indices given, the characters in the words denoted by indices are reversed.

```javascript
var words= new Words('reverse words positions');
console.log( words.reverse().$ );
// positions words reverse

var words= new Words('words are reversed in place when 0 is given');
console.log( words.reverse(0).$ );
// sdrow era desrever ni ecalp nehw 0 si nevig

var words= new Words('any reason to reverse a specific word?');
console.log( words.reverse(1, -1, -2).$ );
// yna reason to reverse a cificeps ?drow
```

**Words.prototype.shuffle**
> `<this> shuffle( <string>/<number> index, [index1, ..., indexN] )`

> Shuffles the word on index, if index is given. If index is/are strings, the matching words will be shuffled. If index is 0, every word is shuffled, but will remain on it's current index, following arguments are ignored. Without arguments, all indices are shuffled.

```javascript
// pseudo random

var words= new Words('let\'s mess up this sentence');
console.log( words.shuffle().$ );
// sentence let's up mess this

var words= new Words('or mess it up totally in place');
console.log( words.shuffle(0).$ );
// ro esms it up ltlotay ni eclpa

var words= new Words('let\'s shuffle some specific words');
console.log( words.shuffle(2, -1).$ );
// let's efsfluh some specific srowd
```

**Words.prototype.clear**
> `<this> clear()`

> Resets this.words to empty [].

**Words.prototype.remove**
> `<this> remove( <string>/<number> indices and or words )`

> Removes any combination of indices or words from this.words. Without arguments remove does nothing. Invalid arguments are ignored

```javascript
var words= new Words('removing specific words is very easy');
console.log( words.remove(2, 3, -2).$ );
// removing is easy
```

**Words.prototype.pop**
> `<string> pop( <string>/<number> amount )`

> Removes the last word from this.words if no arguments are given. If amount is valid, amount words will be removed from this.words, starting from the last word going backwards.

> A string of all words 'popped' in reverse order, will be returned.

```javascript
var words= new Words( 'pop means: get and remove words from the end of this string' );
console.log( words.pop(3) );
// of this string
console.log( words.$ );
// pop means: remove words from the end
```

**Words.prototype.push**
> `<this> push( <string>/<number> word, [word1, ..., wordN] )`

> Adds words to the end of this.words.

```javascript
var words= new Words( 'push means: add to the end of this' );
console.log( words.push( 'string' ).$ );
// push means: add to the end of this string
```

**Words.prototype.shift**
> `<this> shift( <string>/<number> amount )`


> Removes the first word from this.words if no arguments are given. If amount is valid, amount words will be removed from this.words, starting from the first word going forwards.

```javascript
var words= new Words( 'shift means: remove words from the start' );
console.log( words.shift(2).$ );
// remove words from the start
```

**Words.prototype.unshift**
> `<this> unshift( <string>/<number> word, [word1, ..., wordN]  )`

> Adds words to the beginning of this.words.

```javascript
var words= new Words( 'adding words to the start of a string' );
console.log( words.unshift('unshift', 'means:').$ );
// unshift means: adding words to the start of a string
```

**Words.prototype.insert**
> `<this> insert( <string>/<number> index, <string>/<number> word, [word1, ..., wordN]  )`

> Insert word(s) at index of this.words.

```javascript
var words= new Words( 'insert a word in this string' );
console.log( words.insert( 3, 'specific' ).$ );
// insert a specific word in this string
```

**Words.prototype.replace**
> `<this> replace( <string>/<number> selection, <string>/<number> replacement )`

> Replace all words equal to selection to replacement.

```javascript
var words= new Words( 'to replace or not to replace' );
console.log( words.replace('replace', 'be').$ );
// to be or not to be
```


**Words.prototype.sort**
> `<this> sort()`

> Sorts this.words alphabetically

```javascript
var words= new Words( 'testing words is really funny actually' );
console.log( words.sort().$ );
// actually funny is really testing words
```

**Words.prototype.startsWith**
> `<boolean> startsWith( <string>/<number> string )`

> Returns true only if this.words starts with string

```javascript
var words= new Words( 'is this a start or an end?' );
console.log( words.startsWith('is this a start') );
// true
```

**Words.prototype.endsWith**
> `<boolean> endsWith( <string>/<number> string )`

> Returns true only if this.words ends with string

```javascript
var words= new Words( 'is this a start or an end?' );
console.log( words.endsWith('an end?') );
// true
```

__________

change log
==========
**0.4.1**

replaced deprecated code with strings.js dependency
adds babel transpile stage for higher quality bundle code (improved compatibility)
upgraded jasmin testing setup
cleaned up the readme

---

**0.4.0**

changes lisence to MIT

---

**0.3.9**

Updated the included types.js to version 1.5.0.

Deprecated .flexArgs. .flexArgs is now included (in the included) types.js and has been renamed to .intoArray. Use .intoArray instead of .flexArgs which will be removed at some point in time.
___
**0.3.8**

Added AMD support.
___
**0.3.7**

Changed:
- Words.prototype.pop: .pop used to return context to allow for chaining, but I decided to have it return a reverse ordered
(space delimited) string of the popped words instead. I missed that feature and considered it more valuable. Unfortunately
this can break some code, so check your project before upgrading it to this version.

Added Words.flexArgs convenience method in order to allow more flexible input. The constructor and Words.prototype.set are now
accepting: space delimited strings, multiple arguments and array
___
**0.3.6**

Updated the included strings.js to version 1.2.3
___
**0.3.2**

Removed strings.js dependency. types.js (1.4.2) and strings.js (1.2.2) are now included in words.js

___
**0.3.0**

Updated
-	strings.js dependency to the latest version 1.2.1.
-	readme

_______________________________
**0.2.9**

Finaly, the Jasmine tests have arrived. Fixed some minor bugs along the way.

_______________________________
**0.2.7**

Words.upper and Words.lower now accept multiple indices and/or words as mixed arguments.

```javascript
var words= new Words('you can upper or lower with indices and words mixed');
console.log( words.upper('can', 0, 1, 'indices', 'words') );
// [ 'You', 'CAN', 'Upper', 'Or', 'Lower', 'With', 'INDICES', 'And', 'WORDS', 'Mixed' ]

Updated strings.js dependency to version 1.1.9, which includes types.js version 1.3.6.
```
_______________________________
**0.2.4**

Updated strings.js dependency to version 1.1.6, which includes types.js version 1.3.4.
_______________________________
**0.2.0**

Modified:
- Words.prototype.reverse() - The default reverse without arguments no longer reverses all characters. This functionality
was 100% similar to the default Strings.reverse(), so pointless to overload. Now .reverse() reverses the positions
of all words, which is more useful as addition.

Added:
- Words.prototype.startsWith()
- Words.prototype.endsWith()

Don't mind the version please, as for every typo in the readme I have to bump the version for npm..
________________________________
**0.1.2**

words.js now depends on strings.js version 1.1.4.. strings.js now includes types.js version 1.2.8, which is
improved with force'Type'. Check types.js in the phazelift repo for changes and API.

Words.prototype.find only finds words now, use Strings.find for finding characters in words.
Words.prototype.remove(0) has been removed as an option to clear this.words. Not a big thing, I just thought
that we have .clear() for that, so it felt a bit confusing and redundant.

The manual is now more complete and up to date.

Next up are the Jasmine tests!

__________

### lisence
MIT


