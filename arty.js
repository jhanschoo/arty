var checkArgumentType = function (constraint, arg, argn) {
  var checkArgumentTypeHelper = function cat(c, a) {

    if (c === undefined) {
      return true;
    }

    if (typeof(c) === 'string') {
      if (typeof(a) === c) {
        return true;
      }
      return 'Argument ' + argn + ' did not satisfy constraint [\'' + c + '\']';
    }

    if (c === String) {
      if (typeof(a) === 'string' || a instanceof String) {
        return true;
      }
      return 'Argument ' + argn + ' did not satisfy constraint [String]';
    }

    if (c === Number) {
      if (typeof(a) === 'number' || a instanceof Number) {
        return true;
      }
      return 'Argument ' + argn + ' did not satisfy constraint [Number]';
    }

    if (c === Boolean) {
      if (typeof(a) === 'boolean' || a instanceof Boolean) {
        return true;
      }
      return 'Argument ' + argn + ' did not satisfy constraint [Boolean]';
    }

    if (c instanceof Function) {
      if (a instanceof c) {
        return true;
      }
      return 'Argument ' + argn + ' did not satisfy constraint [' + c.toString() + ']';
    }

    if (c instanceof Array) {
      if (!(a instanceof Array)) {
        return 'Argument ' + argn + ' did not satisfy constraint [Array]';
      }
      var l = c.length;
      for (var i = 0; i < l; i++) {
        var r = cat(c[i], a[i]);
        if (r !== true) {
          return r;
        }
      }
      return true;
    }

    if (c instanceof Object) {
      if (!(a instanceof Object)) {
        return 'Argument ' + argn + ' did not satisfy constraint [Object]';
      }
      var k = Object.keys(c);
      var l = k.length;
      for (var i = 0; i < l; i++) {
        var r = cat(c[k[i]], a[k[i]]);
        if (r !== true) {
          return r;
        }
      }
      return true;
    }

    return 'Constraint ' + argn + ' is not a known constraint.'

  };

  return checkArgumentTypeHelper(constraint, arg);
}

var checkArgumentTypes = function (constraints, arg, argn) {
  if (constraints instanceof Array) {
    var errors = [];
    var l = constraints.length;
    for (var i = 0; i < l; i++) {
      var r = checkArgumentType(constraints[i], arg, argn);
      if (r !== true) {
        errors.push(r);
      }
    }
    if (errors.length >= l && l > 0) {
      return errors.join('\n');
    }
    return true;
  }
  return checkArgumentType(constraints, arg, argn);
};

var checkArgumentsTypes = function (sig, arguments) {
  var l = sig.length;
  var errors = [];
  for (var i = 0; i < l; i++) {
    var r = checkArgumentTypes(sig[i], arguments[i], i);
    if (r !== true) {
      errors.push(r);
    }
  }
  if (errors.length !== 0) {
    throw(new Error(errors.join('\n')));
  }
};

var arty = function (/* types here */) { /* t(...) */
  var sig = arguments;
  var f = undefined;

  return function (/* function or arguments passed to the function*/) { /* t('types')(...) */
    if (f) {
      checkArgumentsTypes(sig, arguments);
      return f.apply(this, arguments);
    } else {
      if (arguments[0] && arguments[0] instanceof Function) {
        f = arguments[0];
        return function() {
          checkArgumentsTypes(sig, arguments);
          return f.apply(this, arguments);
        };
      } else {
        throw(new Error('Attempted to define function declaration using a non-Function'));
      }
    }
  };

};

arty.x = function() { /* dummy arty */
  var f = undefined;

  return function (/* function or arguments passed to the function*/) { /* t('types')(...) */
    if (f) {
      return f.apply(this, arguments);
    } else {
      if (arguments[0] && arguments[0] instanceof Function) {
        f = arguments[0];
        return function() {
          return f.apply(this, arguments);
        };
      } else {
        throw(new Error('Attempted to define function declaration using a non-Function'));
      }
    }
  };

};

module.exports = arty;