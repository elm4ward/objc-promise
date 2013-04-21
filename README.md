# objc-promise
### A CommonJS-style promise library for iOS

This fork adds underscore.m like chaining.
The idea behind this fork is to add a more fluent interface for handling promises.
This is inspired by the amazing [underscorem.org](https://github.com/robb/Underscore.m).

Current usage is demonstarted in [WhenTests.m](https://github.com/elm4ward/objc-promise/blob/master/objc-promiseTests/WhenTests.m):
No recommendation for production use of When.m as the work is still in progress.


## Example

```objectivec

// Initital When
[When block:^(Deferred *dfd) {
  doDelayed(2, ^{
    [dfd resolve:@"First"];
  });
}]
// first callback
.then(^(id resolve){
  return @"first callback is done";
},^id(id error){
  return nil;
})
// 2nd callback
.then(^(id resolve){
   return [Deferred deferredWithBlock:^(Deferred *dfd) {
     doDelayed(3, ^{
      [dfd resolve:@"second callback is done"];
     });
    }];
},^id(id error){
  return nil;
})
```

## License

Source code for _objc-promise_ is Copyright © 2012 [Mike Roberts](mailto:mike@kik.com).

Source code for When && WhenTests is Copyright © 2013 [Elmar Kretzer](mailto:catchmoments@4ward.org).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
