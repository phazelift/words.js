words.js
========

words.js is an addition to my strings.js library, and operates primarily on single word-strings instead of
individual characters.

This is in a very early stage of development, things will change for sure, use with care.

This manual is still incomplete, will try to complete soon.

Words are seperated by spaces.


<br/><br/>
___
API
---

**Words.prototype.constructor**
> `<object>constructor( <string>/<number> string= '', <string>/<number> delimiter= ' ' )`

> Initializes the contextual object.

**Words.prototype.set**
> `<string> set( <string>/<number> index, [index1, ..., indexN] )`

**Words.prototype.get**
> `<string> get( <string>/<number> index, [index1, ..., indexN] )`

> Returns the word(s) found at index(es).

**Words.prototype.find**
> `<array> find( <string>/<number> substring, <boolean> addPositions= false )`

> Returns an array containing all indices(numbers) in this.words where substring is found. If addPositions is set
> true, also the position within the found word is returned, and the result will be an array of arrays with indices.

**Words.prototype.upper**
> `<string> upper( <string>/<number> index, <string>/<number> position )`

**Words.prototype.lower**
> `<string> lower( <string>/<number> index, <string>/<number> position )`

**Words.prototype.reverse**
> `<array> reverse( <string>/<number> index, [index1, ..., indexN] )`

> Reverses the word on index if index is given. If index is 0, every word is reversed, but will remain on it's
> current index, every following index will not be reversed. Without arguments, all words and all indices are reversed.

**Words.prototype.shuffle**
> `<array> shuffle( <string>/<number> index, [index1, ..., indexN] )`

> Shuffles the word on index, if index is given. If index is/are strings, the matching words will be shuffled.
> If index is 0, every word is shuffled, but will remain on it's current index, following arguments are ignored.
> Without arguments, all indices are shuffled.





