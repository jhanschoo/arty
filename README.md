arty
=====

tiny javascript library for asserting types on function arguments

Examples:

```javascript
t = require('arty');

var add = function (n1, n2) {
  return n1 + n2;
};

console.log(add(3, 4)); // => 7
console.log(add(3, {})) // => 3[object Object]


var typed_add = t('number', 'number')(function (n1, n2) {
  return n1 + n2;
});


var typed_subtract = t('number', 'number'); /* function declaration */

var typed_subtract(function (n1, n2) { /* function definition */
  return n1 - n2;
});


var times = function (n1, n2) { return n1 * n2; };
var typed_times = t('number', 'number')(multiplication);
```

To test:

    npm install
    mocha --compilers coffee:coffee-script/register

Have a look at the BSS test script in the test folder to see how the library behaves against various input. (The test cases pretty much comprehensively describes the functionality of this library)
