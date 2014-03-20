var arty = function (/* param_types */) {
  var type_constraints = arguments
  var check_types = function(a) {
    // check arguments pattern matching arguments with type_constraints
    for (var i = 0, ii = type_constraints.length; i < ii; i++) {
      var t = type_constraints[i];
      var p = a[i];
      // TODO(jhanschoo): implement the actual type checking for each argument.
    }
  }
  return function (wrapped_function) {
    return function (/* params */) {
      check_types(arguments);
      return wrapped_function.apply(this, arguments);
    }
  }
};

module.exports = arty;

// to use, call:
// var typed_f = arty('string', 'number', 'boolean')(function () {
// });
//
// typed_f('string', 4, true);
