# Learn Typescript types

> How Typescript applies types to variables

`Simple types`

```javascript
// Boolean
let isDone: boolean = false;

// String
let fullName: string = `Jacky So`;
let greeting: string = `Hello, my name is ${fullName}`;

// Number
let decimal: number = 8;
let float: number = 99.456
let exponential: number = 3.4E5678;
let hex: number = 0xf01a;
let binary: number = 0b0101;
let octal: number = 0o477;
```

> Besides simple types as in others, there are additional types in Typescript

* Array

```javascript
// Array
let list: number[] = [4, 5, 6];
let list2: string[] = [`Jacky`, `Natalie`];
// Array in angle bracket notation
let list1: Array<number>  = [4, 5, 6];
let list3: Array<string>  = [`Jacky`, `Natalie`];
```

* Tuple

```javascript

// Tuple - array of fixed (or variable) length but differing types, ? on a type means that it is optional
let person:[string, number, number?] = [`Jacky`, 56];

person[2] = `So`; // Error
person[2] = 1234; // OK
person[3] = 1234; // Error, exceed length
```

* Enum

```javascript
// Enum
// Automatically numbered from 0
enum Color {Red, Green, Blue};
let c: Color = Color.Green;
// Can start from any number
enum Color {Red=4, Green, Blue};
let c: Color = Color.Green;
// Number them all manually, your choice
enum Color {Red=4, Green=8, Blue=16};
let c: Color = Color.Green;
// Go from numeric value to name, need to declare type
enum Color {Red=4, Green=8, Blue=16};
let c: string = Color[8];
```

* Any

```javascript
// Types - Any
let thing: any = `Thing T. Thing`;
thing = false;
// You don't know types of all
let list4: any[] = [1, true, thing];
```

* Void

```javascript
// Void - opposite of Any
// for type of functions that don't returen a value
function absenceOfThing(): void {
	alert(`Thing has gone AWOL`);
}
// Can only assign null or undefined
let unusable: void = undefined;
unusable = null; // OK; Error when strictnullChecks is true
// unusable = true; // Error
```

* Union types

```javascript
// Union type
// Add "strictNullChecks": true in tsconfig.json to ensure compiler return error
// let aNumber: number = null;
let aNumber: string|null = `Hi`;
aNumber = null; // OK
```

> `tsconfig.json`


```json
{
    "compilerOptions": {
        "outDir": "bin",
	"resolveJsonModule": true,
        "target": "es2016",
        "module": "commonjs",
        "moduleResolution": "node",
        "sourceMap": true,
        "experimentalDecorators": true,
        "pretty": true,
        "noFallthroughCasesInSwitch": true,
        "noImplicitAny": true,
        "noImplicitReturns": true,
        "forceConsistentCasingInFileNames": true,
        "strictNullChecks": true
    },
    "files": [
        "index.ts"
    ]
}
```

* Never

```
// Type never is a subtype of every type but nothing is a subtype of never, never represents the type of values that never occur
// functions that never return
function notEver(): never {
	while (true) {}
}
// functions that always throw
function alwaysThrow(): never {
	throw new Error("throwing");
}
```

* Object

```javascript
// Object type
declare function create(o: object|null): void;
// Validation
create({prop: 0}); // OK
create(null); // OK; null in Union type
create(42); // Error; type number is not assignment to type object
create(`string`); // Error; type string is not assignment to type object
// Testing
declare function create1(o: object|string): void;
create1(`string`); // OK
```

* Overrides

```javascript
// Override the compiler - specific than its current type
// Typescript provides 2 syntaxes
// angle-bracket syntax
let nameLength: number = (<string>thing).length;
// as-syntax
let nameLength1: number = (thing as string).length;
```

* Unknown

```javascript
// Unknown top-type - Introduced in Typescript v3.0
// Type-safe counterpart of type any
// Anything is assignable to unknown
// Type unknow isn't assignable to anything but itself and any without a type-assertion or control flow based narrowing
// No operations are permitted on an unknown type without assertion or narrowing
let x: unknown = `Hi`; // OK
x = 42; // OK
x !== 10; // OK
x <= 22; // OK?
(x as number) >= 10; // OK
(x as number) = 100;
```
