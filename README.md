arty
=====

tiny javascript library for asserting types on function arguments

To use:

    t = require('arty');

    var add = function (n1, n2) {
      return n1 + n2;
    };

    console.log(add(3, 4));
    => 7
    console.log(add(3, {}))
    => 3[object Object]


    var typed_add = t('number', 'number')(function (n1, n2) {
      return n1 + n2;
    });


    var typed_subtract = t('number', 'number'); /* function declaration */
    
    var typed_subtract(function (n1, n2) { /* function definition */
      return n1 - n2;
    });


    var times = function (n1, n2) { return n1 * n2; };
    var typed_times = t('number', 'number')(multiplication);


To test:

    npm install
    mocha --compilers coffee:focceescript/register
