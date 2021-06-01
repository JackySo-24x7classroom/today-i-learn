# Learn Javascript - var Vs let Vs const

> `let` and `const` are come with ES2015 (ES6), what are difference when using them comparing to our old friend `var`

* `var` variables can be re-declared and updated

* `let` variables  can be updated but not re-declared

* `const` variables cannot be updated or re-declared - So anytime you want a variable to be immutable, you can declare it with const

```
$  node
> // var
> var apple;
> apple = "fruit";
'fruit'
> console.log(apple);
fruit
> apple = "healthy";
'healthy'
> console.log(apple);
healthy
> // let;
> let orange;
> orange = "fruit";
'fruit'
> console.log(orange);
fruit
> orange = "healthy";
'healthy'
> console.log(orange);
healthy
> let orange = "again";
Thrown:
SyntaxError: Identifier 'orange' has already been declared
> var apple = "again";
> console.log(apple);
again
> // const;
> const banana;
Thrown:
const banana;
      ^^^^^^

SyntaxError: Missing initializer in const declaration
> const banana = "fruit";
> console.log(banana);
fruit
> banana = "again";
Thrown:
TypeError: Assignment to constant variable.
> const banana = "again";
Thrown:
SyntaxError: Identifier 'banana' has already been declared
```

> Revisit the said of you want a variable to be immutable, you can declare it with const.

> Not exactly. Just a variable is declared with const doesn’t mean it’s immutable, all it means is the value can’t be re-assigned.

> See the interesting examples as follows:

```
// const example
> const person = {
...   name: 'Kim Kardashian'
... }
> console.log(person);
{ name: 'Kim Kardashian' }
> console.log(person.name);
Kim Kardashian
> person = { name: 'Good Luck' };
Thrown:
TypeError: Assignment to constant variable.
> person.name = 'Good Luck';
'Good Luck'
> console.log(person);
{ name: 'Good Luck' }
> console.log(person.name);
Good Luck

// var example
> var person1 = {
... name: 'Kim Kardashian'
... }
> console.log(person1);
{ name: 'Kim Kardashian' }
> console.log(person1.name);
Kim Kardashian
> person1 = { name: 'Good Luck' };
{ name: 'Good Luck' }
> console.log(person1.name);
Good Luck
> var person1 = {};
> console.log(person1);
{}
> console.log(person1.name);
undefined

// let example
> let person2 = {
... name: 'Kim Kardashian' };
> console.log(person2.name);
Kim Kardashian
> person2 = { name: 'Good Luck' };
{ name: 'Good Luck' }
> console.log(person2.name);
Good Luck
> let person2 = {
... name: 'How come'
... };
Thrown:
SyntaxError: Identifier 'person2' has already been declared
> .exit
```

`Note`: By changing a property on an object isn’t reassigning it, so even though an object is declared with `const`, that doesn’t mean you can’t mutate any of its properties. It only means you can’t reassign it to a new value.

`Scopes:` Global Vs Block

`test.js`

```javascript
/*
 * Examples to compare var, let, and const when using
 * in global and block scopes
 */ 

// var example
console.log("Start of var");
var greeting1 = "say Hi";
var x = 4;

if (x > 3) {
	var greeting1 = "Good luck"
	var hello = greeting1;
	console.log(hello); // Block scope
}
console.log(greeting1) // Interest. Global scope seems overriden
console.log("End of var");

// let example
console.log("Start of let");
let greeting2 = "say Hi";

if (x > 3) {
	let greeting2 = "Good luck"
	let hello = greeting2;
	console.log(hello); // Block scope
}
console.log(greeting2) // Global scope
console.log("End of let");

// const example
console.log("Start of const");
const greeting3 = "say Hi";

if (x > 3) {
	const greeting3 = "Good luck"
	const hello = greeting2;
	console.log(hello); // Block scope
}
console.log(greeting3) // Global scope
console.log("End of const");
```

> See results

<pre>
$  node test.js
<span style="color:blue">
Start of var
Good luck
Good luck
End of var</span>
<span style="color:green">
Start of let
Good luck
say Hi
End of let</span>
<span style="color:red">
Start of const
say Hi
say Hi
End of const</span>
</pre>

***Note:*** `const` is immutable in all scopes and cannot reassign value in block

[Var, Let, and Const – What's the Difference?]: https://www.freecodecamp.org/news/var-let-and-const-whats-the-difference/

[var vs let vs const in JavaScript]: https://ui.dev/var-let-const/

[Const vs Let vs Var in Javascript. Which One Should You Use?]: https://levelup.gitconnected.com/const-vs-let-vs-var-in-javascript-which-one-should-you-use-c56cf9b9e2a3

[JavaScript ES6+: var, let, or const?]: https://medium.com/javascript-scene/javascript-es6-var-let-or-const-ba58b8dcde75
