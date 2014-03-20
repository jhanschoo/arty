var t = function (flag) {
  return function (/* param_types */) {
    var type_constraints = arguments;

    // handles type checking of an outer argument
    var check_outer_arg = function (t, a) {
      var v;
      if (t instanceof Array) {
        for (var i = 0, ii = t.length; i < ii; i++) {
          if (v = check_arg(t[i], a)) { return v; }
        }
        return v;
      }
      return check_arg(t, a);
    }

    // handles type checking of an argument
    var check_arg = function (t, a) {
      var t_type = typeof t;
      if (t_type === 'undefined') { return true; }
      if (t_type === 'string') { return check_string(t, a) };
      if (t instanceof Array) {
        // TODO(jhanschoo)
      }
      if (t instanceof Object) {
        // TODO(jhanschoo)
      }
    }

    // handles checking where the
    // type constraint is a string type
    var check_string = function (s, a) {
      var t = typeof a;
      if (s === t) { return true; }
      return false;
      // TODO(jhanschoo): improve failure return
      // value to be more than just false
    };
    var check_args = function (a) {
      // check arguments pattern matching arguments with type_constraints
      for (var i = 0, ii = type_constraints.length; i < ii; i++) {
        var t = type_constraints[i];
        var p = a[i];
        // TODO(jhanschoo): implement the actual type checking for each argument.
      }
    };
    return function (wrapped_function) {
      return function (/* params */) {
        check_args(arguments);
        return wrapped_function.apply(this, arguments);
      };
    };
  };
};

var arty = t();

arty.rty = arty
arty.arty = arty
arty.farty = t('f');
arty.sarty = t('s');

// TODO(jhanschoo): arty.message.error = '....'

module.exports = arty;

// to use, call:
// var typed_f = arty('string', 'number', 'boolean')(function () {
// });
//
// typed_f('string', 4, true);
