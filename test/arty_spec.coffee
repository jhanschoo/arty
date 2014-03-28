t = require '../arty'
expect = require('chai').expect

d = -> 'valid'

describe 'arty', ->

  describe 'after being initialized with a function signature', ->
    it 'should allow functions to be defined on it', ->
      tNull = t()
      expect(-> tNull(->)).to.not.throw(Error)

    it 'should not allow other types to be defined on it', ->
      tNull = t()
      expect(-> tNull('string')).to.throw('Attempted to define function declaration using a non-Function')

  
  it 'should execute the function it types', ->
    f = t() d
    expect(f()).to.equal 'valid'

  
  it 'should check for strings with t("string")', ->
    fString = t('string') d

    expect(fString('')).to.equal 'valid'
    expect(-> fString(new String('hello'))).to.throw 'Argument 0 did not satisfy constraint [\'string\']'
    expect(-> fString({})).to.throw 'Argument 0 did not satisfy constraint [\'string\']'

  it 'should check for strings and instances of String with t(String)', ->
    fString = t(String) d

    expect(fString('')).to.equal 'valid'
    expect(fString(new String('hello'))).to.equal 'valid'
    expect(-> fString({})).to.throw('Argument 0 did not satisfy constraint [String]')


  it 'should check for numbers with t("number")', ->
    fNumber = t('number') d

    expect(fNumber(42)).to.equal 'valid'
    expect(-> fNumber(new Number(42))).to.throw 'Argument 0 did not satisfy constraint [\'number\']'
    expect(-> fNumber({})).to.throw 'Argument 0 did not satisfy constraint [\'number\']'

  it 'should check for numbers with t(Number)', ->
    fNumber = t(Number) d
    expect(fNumber(42)).to.equal 'valid'
    expect(fNumber(new Number())).to.equal 'valid'
    expect(-> fNumber({})).to.throw 'Argument 0 did not satisfy constraint [Number]'

  it 'should check for booleans with t("boolean")', ->
    fBoolean = t('boolean') d
    expect(fBoolean(true)).to.equal 'valid'
    expect(-> fBoolean(new Boolean(true))).to.throw 'Argument 0 did not satisfy constraint [\'boolean\']'
    expect(-> fBoolean({})).to.throw 'Argument 0 did not satisfy constraint [\'boolean\']'

  it 'should check for booleans with t(Boolean)', ->
    fBoolean = t(Boolean) d
    expect(fBoolean(new Boolean())).to.equal 'valid'
    expect(-> fBoolean({})).to.throw 'Argument 0 did not satisfy constraint [Boolean]'

  it 'should not check for anything with t([]) (equivalent to t(undefined))', ->
    fArray = t([]) d
    expect(fArray(['this', 'that'])).to.equal 'valid'
    expect(fArray(42)).to.equal 'valid'

  it 'should check for arrays with t([[]])', ->
    fArray = t([[]]) d
    expect(fArray(['this', 'that'])).to.equal 'valid'
    expect(-> fArray(42)).to.throw Error
    expect(-> fArray({ '0': 'a', '1': 'b' })).to.throw Error

  it 'should check for objects with t({})', ->
    fObject = t({}) d
    expect(fObject({ 'a': 'b', 'c': 0})).to.equal 'valid'
    expect(-> fObject(42)).to.throw Error
    expect(-> fObject(null)).to.throw Error

  it 'should check for objects with t(Object)', ->
    fObject = t(Object) d
    expect(fObject({ 'a': 'b', 'c': 0})).to.equal 'valid'
    expect(-> fObject(42)).to.throw Error
    expect(-> fObject(null)).to.throw Error

  it 'should check for objects types with t("object")', ->
    fObject = t("object") d
    expect(fObject 'a': 'b', 'c': 0).to.equal 'valid'
    expect(-> fObject 42).to.throw Error
    expect(fObject null).to.equal 'valid'

  it 'should check for arguments that match a type in a list', ->
    fStringList = t([String, []]) d
    fBoolean = t([Boolean]) d
    fListString = t([[], String]) d

    expect(fStringList ['hello']).to.equal 'valid'
    expect(fStringList 'world').to.equal 'valid'
    expect(-> fStringList 32).to.throw Error

    expect(-> fBoolean []).to.throw Error
    expect(fBoolean false).to.equal 'valid'

  it 'should check deeply into arrays', ->
    fArray = t([[String, Number]]) d

    expect(fArray ['hello', 42]).to.equal 'valid'
    expect(-> fArray ['world', 'baz']).to.throw Error

  it 'should check deeply into objects and arrays for matching a schema', ->
    fObject = t(
      [
        {
          'property1': String
          'property2': Number
        }
        {
          'property1': Number
          'property3': {
            'property3_1': [
              String, Array
            ]
          }
        }
      ]
    ) d

    expect(fObject {
      'property1': 'foo'
      'property2': 0.2
      'propertynein': 'dummy'
    }).to.equal 'valid'

    expect(fObject {
      'property1': 923
      'property3': {
        'property0': 'foo'
        'property3_1': ['bar', ['baz']]
      }
    }).to.equal 'valid'

    expect(-> fObject ['world', 'baz']).to.throw Error
    expect(-> fObject {
      'property1': 'hello'
      'property3': {
        'property0': 'foo'
        'property3_1': ['bar', ['baz']]
      }
    }).to.throw Error

    expect(-> fObject {
      'property1': 1234
      'property3': {
        'property0': 'foo'
        'property3_1': ['bar', 123]
      }
    }).to.throw Error

  it 'should check for arguments in the second position with t(undefined, constraint)', ->
    fObject = t(undefined,
      [
        {
          'property1': String
          'property2': Number
        }
        {
          'property1': Number
          'property3': {
            'property3_1': [
              String, Array
            ]
          }
        }
      ]
    ) d

    expect(fObject 'Darth Vader', {
      'property1': 'foo'
      'property2': 0.2
      'propertynein': 'dummy'
    }).to.equal 'valid'

    expect(fObject 'Luke Skywalker', {
      'property1': 923
      'property3': {
        'property0': 'foo'
        'property3_1': ['bar', ['baz']]
      }
    }).to.equal 'valid'

    expect(-> fObject 'Spock', ['world', 'baz']).to.throw Error
    expect(-> fObject {
      'property1': 'hello'
      'property3': {
        'property0': 'foo'
        'property3_1': ['bar', ['baz']]
      }
    }).to.throw Error

    expect(-> fObject {
      'property1': 1234
      'property3': {
        'property0': 'foo'
        'property3_1': ['bar', 123]
      }
    }, 'Nietzsche').to.throw Error
