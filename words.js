// Generated by CoffeeScript 1.8.0
(function() {
  "use strict";
  var Str, Strings, Words, applyToValidIndex, changeCase, delimiter, insertSort, removeDupAndFlip, _,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Strings = Str = _ = require('strings.js');

  removeDupAndFlip = function(array) {
    var index, length, newArr, _i;
    length = array.length - 1;
    newArr = [];
    for (index = _i = length; length <= 0 ? _i <= 0 : _i >= 0; index = length <= 0 ? ++_i : --_i) {
      if (newArr[newArr.length - 1] !== array[index]) {
        newArr.push(array[index]);
      }
    }
    return newArr;
  };

  insertSort = function(array) {
    var current, index, length, prev, _i;
    length = array.length - 1;
    for (index = _i = 1; 1 <= length ? _i <= length : _i >= length; index = 1 <= length ? ++_i : --_i) {
      current = array[index];
      prev = index - 1;
      while ((prev >= 0) && (array[prev] > current)) {
        array[prev + 1] = array[prev];
        --prev;
      }
      array[+prev + 1] = current;
    }
    return array;
  };

  changeCase = function(method, args) {
    var index, pos, _i, _j, _k, _len, _len1, _ref, _results, _results1, _results2;
    if (_.isString(args != null ? args[0] : void 0)) {
      return this.set(Str[method].apply(Str, [this.$].concat(__slice.call(args))));
    } else if ((args != null ? args[0] : void 0) === 0) {
      _results = [];
      for (_i = 0, _len = args.length; _i < _len; _i++) {
        pos = args[_i];
        _results.push((function() {
          var _j, _ref, _results1;
          _results1 = [];
          for (index = _j = 0, _ref = this.count - 1; 0 <= _ref ? _j <= _ref : _j >= _ref; index = 0 <= _ref ? ++_j : --_j) {
            _results1.push(this.words[index] = Str[method](this.words[index], pos));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    } else {
      if (args.length < 1) {
        args = (function() {
          _results1 = [];
          for (var _j = 0, _ref = this.count; 0 <= _ref ? _j <= _ref : _j >= _ref; 0 <= _ref ? _j++ : _j--){ _results1.push(_j); }
          return _results1;
        }).apply(this);
      }
      _results2 = [];
      for (_k = 0, _len1 = args.length; _k < _len1; _k++) {
        pos = args[_k];
        pos = _.positiveIndex(pos, this.count);
        _results2.push(this.words[pos] = Str[method](this.words[pos]));
      }
      return _results2;
    }
  };

  applyToValidIndex = (function(_this) {
    return function(orgIndex, limit, callback) {
      var index;
      if (false !== (index = _.positiveIndex(orgIndex, limit))) {
        return callback(index);
      }
    };
  })(this);

  delimiter = ' ';

  Words = (function(_super) {
    __extends(Words, _super);

    function Words() {
      this.set.apply(this, arguments);
    }

    Words.prototype.set = function() {
      var arg, str, _i, _j, _len, _len1, _ref;
      if (arguments.length < 1) {
        return this;
      }
      this.words = [];
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        arg = arguments[_i];
        _ref = Str.split(Str.create(arg), delimiter);
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          str = _ref[_j];
          this.words.push(str);
        }
      }
      return this;
    };

    Words.prototype.get = function() {
      var index, string, _i, _len;
      if (arguments.length < 1) {
        return this.words.join(delimiter);
      }
      string = '';
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        index = arguments[_i];
        index = _.positiveIndex(index, this.count);
        if (index !== false) {
          string += this.words[index] + delimiter;
        }
      }
      return Str.trim(string);
    };

    Words.prototype.xs = function(callback) {
      var index, response, result, word, _i, _len, _ref;
      if (callback == null) {
        callback = function() {
          return true;
        };
      }
      if (_.notFunction(callback) || this.count < 1) {
        return;
      }
      result = [];
      _ref = this.words;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        word = _ref[index];
        if (response = callback(word, index)) {
          if (response === true) {
            result.push(word);
          } else if (_.isStringOrNumber(response)) {
            result.push(response + '');
          }
        }
      }
      this.words = result;
      return this;
    };

    Words.prototype.find = function(string) {
      var indices;
      indices = [];
      if ('' !== (string = _.forceString(string))) {
        this.xs(function(word, index) {
          if (word === string) {
            indices.push(index + 1);
          }
          return true;
        });
      }
      return indices;
    };

    Words.prototype.upper = function() {
      changeCase.call(this, 'upper', Array.prototype.slice.call(arguments));
      return this;
    };

    Words.prototype.lower = function() {
      changeCase.call(this, 'lower', Array.prototype.slice.call(arguments));
      return this;
    };

    Words.prototype.reverse = function() {
      var arg, _i, _len;
      if ((arguments != null ? arguments[0] : void 0) === 0) {
        this.xs(function(word) {
          return Str.reverse(word);
        });
      } else if (arguments.length > 0) {
        for (_i = 0, _len = arguments.length; _i < _len; _i++) {
          arg = arguments[_i];
          applyToValidIndex(arg, this.count, (function(_this) {
            return function(index) {
              return _this.words[index] = Str.reverse(_this.words[index]);
            };
          })(this));
        }
      } else {
        this.xs((function(_this) {
          return function(word, index) {
            return _this.get(_this.count - index);
          };
        })(this));
      }
      return this;
    };

    Words.prototype.shuffle = function(selection) {
      var arg, _i, _j, _len, _len1;
      if (selection != null) {
        if (_.isString(selection)) {
          for (_i = 0, _len = arguments.length; _i < _len; _i++) {
            arg = arguments[_i];
            this.xs((function(_this) {
              return function(word, index) {
                if (word === arg) {
                  return Str.shuffle(word);
                }
                return true;
              };
            })(this));
          }
        } else if (selection === 0) {
          this.xs(function(word) {
            return Str.shuffle(word);
          });
        } else {
          for (_j = 0, _len1 = arguments.length; _j < _len1; _j++) {
            arg = arguments[_j];
            applyToValidIndex(arg, this.count, (function(_this) {
              return function(index) {
                return _this.words[index] = Str.shuffle(_this.words[index]);
              };
            })(this));
          }
        }
      } else {
        this.words = _.shuffleArray(this.words);
      }
      return this;
    };

    Words.prototype.clear = function() {
      this.words = [];
      return this;
    };

    Words.prototype.remove = function() {
      var arg, args, index, _i, _j, _len, _len1;
      if (arguments.length < 1) {
        return this;
      }
      args = [];
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        arg = arguments[_i];
        if (_.isString(arg)) {
          args.unshift(arg);
        } else if (_.isNumber(arg)) {
          args.push(Words.positiveIndex(arg, this.count));
        }
      }
      args = removeDupAndFlip(insertSort(args));
      for (index = _j = 0, _len1 = args.length; _j < _len1; index = ++_j) {
        arg = args[index];
        if (_.isNumber(arg)) {
          this.xs((function(_this) {
            return function(word, index) {
              if (index !== arg) {
                return true;
              }
            };
          })(this));
        } else if (_.isString(arg)) {
          this.xs(function(word) {
            if (word !== arg) {
              return true;
            }
          });
        }
      }
      return this;
    };

    Words.prototype.pop = function(amount) {
      var n, _i;
      amount = _.forceNumber(amount, 1);
      for (n = _i = 1; 1 <= amount ? _i <= amount : _i >= amount; n = 1 <= amount ? ++_i : --_i) {
        this.words.pop();
      }
      return this;
    };

    Words.prototype.push = function() {
      var arg, _i, _len;
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        arg = arguments[_i];
        if ('' !== (arg = _.forceString(arg))) {
          this.words.push(Str.trim(arg));
        }
      }
      return this;
    };

    Words.prototype.shift = function(amount) {
      var n, _i;
      amount = _.forceNumber(amount, 1);
      for (n = _i = 1; 1 <= amount ? _i <= amount : _i >= amount; n = 1 <= amount ? ++_i : --_i) {
        this.words.shift();
      }
      return this;
    };

    Words.prototype.prepend = function() {
      var arg, count, _i, _len;
      for (count = _i = 0, _len = arguments.length; _i < _len; count = ++_i) {
        arg = arguments[count];
        if ('' !== (arg = _.forceString(arg))) {
          this.words.splice(count, 0, Str.trim(arg));
        }
      }
      return this;
    };

    Words.prototype.insert = function() {
      var count, index, word, words, _i, _len;
      index = arguments[0], words = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      index = _.positiveIndex(index, this.count);
      for (count = _i = 0, _len = words.length; _i < _len; count = ++_i) {
        word = words[count];
        if ('' !== (word = _.forceString(word))) {
          this.words.splice(index + count, 0, Str.trim(word));
        }
      }
      return this;
    };

    Words.prototype.replace = function(selection, replacement) {
      if (replacement == null) {
        replacement = '';
      }
      if ('' === (replacement = Str.trim(replacement))) {
        return this;
      }
      if (_.isNumber(selection)) {
        applyToValidIndex(selection, this.count, (function(_this) {
          return function(index) {
            return _this.words.splice(index, 1, replacement);
          };
        })(this));
      } else {
        this.xs(function(word) {
          if (word === selection) {
            return replacement;
          }
          return true;
        });
      }
      return this;
    };

    Words.prototype.sort = function() {
      insertSort(this.words);
      return this;
    };

    Words.prototype.startsWith = function(start) {
      var result;
      if ('' === (start = _.forceString(start))) {
        return false;
      }
      result = true;
      start = new Words(start);
      start.xs((function(_this) {
        return function(word, index) {
          if (word !== _this.words[index]) {
            return result = false;
          }
        };
      })(this));
      return result;
    };

    Words.prototype.endsWith = function(end) {
      var count, index, result, _i, _ref;
      if ('' === (end = _.forceString(end))) {
        return false;
      }
      result = true;
      count = 1;
      end = new Words(end);
      for (index = _i = _ref = end.count; _ref <= 1 ? _i <= 1 : _i >= 1; index = _ref <= 1 ? ++_i : --_i) {
        if (end.get(index) !== this.words[this.count - count++]) {
          result = false;
        }
      }
      return result;
    };

    return Words;

  })(Strings);

  Object.defineProperty(Words.prototype, '$', {
    get: function() {
      return this.get();
    }
  });

  Object.defineProperty(Words.prototype, 'string', {
    get: function() {
      return this.get();
    }
  });

  Object.defineProperty(Words.prototype, 'count', {
    get: function() {
      return this.words.length;
    }
  });

  Words.prototype.unshift = Words.prototype.prepend;

  Words.Strings = Strings;

  Words.Types = Strings.Types;

  Words.Chars = Strings.Chars;

  if (typeof window !== "undefined" && window !== null) {
    return window.Words;
  }

  if (module) {
    return module.exports = Words;
  }

}).call(this);
