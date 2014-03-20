arty
=====

**warning: this library is not yet implemented**

tiny javascript library for asserting types on function arguments

To use:

    arty = require('arty');

    var add = function (n1, n2) {
      return n1 + n2;
    };

    console.log(add(3, 4));
    => 7
    console.log(add(3, {}))
    => 3[object Object]

    var typed_add = arty('number', 'number')(function (n1, n2) {
      return n1 + n2;
    });

    var bin_num_arty = arty('number', 'number');
    var typed_subtract = bin_num_arty(function (n1, n2) {
      return n1 - n2;
    });

    var times = function (n1, n2) { return n1 * n2; };
    var typed_times = arty('number', 'number')(multiplication);

