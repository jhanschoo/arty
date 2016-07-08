arty
=====

tiny javascript library for asserting types, as well as array object schemas on function arguments during runtime

Examples:

```javascript
// Require the file
t = require('arty');

// We are going to assert types on this function
var add = function (n1, n2) {
  return n1 + n2;
};

// Some sample output of the add function when called with various input
console.log(add(3, 4)); // => 7
console.log(add(3, {})) // => 3[object Object]

// 1. We can declare a typed function like this
var typed_add = t('number', 'number')(function (n1, n2) {
  return n1 + n2;
});

// Alternatively, we can use t like this; at the top of the file we can 'declare' the type of the function
var typed_subtract_declaration = t('number', 'number'); /* function declaration */

// After which, we implement the function
var typed_subtract = typed_subtract_declaration(function (n1, n2) { /* function definition */
  return n1 - n2;
});


var times = function (n1, n2) { return n1 * n2; };

// 3. You can create a typed function in this manner too.
var typed_times = t('number', 'number')(multiplication);
```

To test:

    npm install
    mocha --compilers coffee:coffee-script/register

Have a look at the BSS test script in the test folder to see how the library behaves against various input. (The test cases pretty much comprehensively describes the functionality of this library)
