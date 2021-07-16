# Learn Typescript class

![cover-image](images/IMG_3452.JPG)

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Typescript class](#typescript-class)
- [Use case study](#use-case-study)

<!-- vim-markdown-toc -->

## Typescript class

> How Typescript works with Javascript implementation of classes and inheritance

> In addition, see below some Typescript features

* Allowed access modifiers
* Typescript `public`, `private`, and `protected` properties
* Use `get` and `set` with classes
* How `abstract classes` are implemented
* Use of `static` keyword

1. `public, private, and protected` and class extension

```javascript
// Learn Typescript class

// Javascript has no implementation of Public, Private and Protected, and Typescript does.
// Public is the default behavior but can also be specified

class Vehicle {
	private wheels: number;
	// protected wheels: number; // Protected acts as like private except protected members can be accessed by deriving classes
	// private power: number;
	private power: number;
	public speed: number = 0;
	
	// private constructor (wheels: number, power: number) {
	// protected constructor (wheels: number, power: number) { // protect constructors to enable extension but not instantiation
	public constructor (wheels: number, power: number) {
		this.wheels = wheels;
		this.power = power;
	}

	public accelerate(time: number) {
		this.speed = this.speed + 0.5*this.power*time;
	}
}

// Extend class - extends and super keywords allow sub-classing
class Car extends Vehicle {
	gps: boolean;
	constructor (wheels, power) {
		super(wheels, power); // Call the parent constructor
		this.gps = true; // GPS as standard
	}
	public showSpeed() {
		return `Current speed: ${this.speed}`
	}
} 

let myCar = new Car(4, 20); // constructor called
// let myVehicle = new Vehicle(4,20); // Error constructor is private use or protected to only accessible within the class declaration

// console.log(myCar.speed); // OK, Property speed is public and accessible beyond class Vehicle
// console.log(myCar.wheels); // Error, Property wheel is private and only accessible within class Vehicle
// console.log(myCar.showSpeed()); //
```

2. Simple class construction and declaration in implementation

```javascript
// Typescript allow class variables to be declared and assigned in shorthand
// Simply include the access modifier in the constructor argument and leave function body empty
class Car1 {
	constructor(
		public wheels: number,
		public power: number,
		public make: string,
		public speed: number = 0 // Default
	) {} // function body empty
}

let myCar1 = new Car1(4, 20, `Ford`); // constructor called - declare class variable and assigned
console.log(myCar1.speed); //
```

3. `Readonly` properties

```javascript
// Readonly properties must be initialized at their declaration or in the constructor

class Vehicle10 {
	readonly wheels: number;
	readonly power: number;
	protected speed: number = 0;
	
	constructor (wheels: number, power: number) {
		this.wheels = wheels;
		this.power = power;
	}

	accelerate(time: number) {
		this.speed = this.speed + 0.5*this.power*time;
	}
}

class Car10 extends Vehicle10 {
	readonly gps: Boolean = true;
	constructor (wheels, power) {
		super(wheels, power);
	}
}

let myCar10 = new Car10(4, 20);
// myCar10.wheels = 3; // Error; wheels in Car10 is readonly property
console.log(myCar10.wheels); // 4
```

4. Getter and Setting in class

```javascript
// Classes: getter and setters - add logics to properties
// Need es5 to run - tsc -t es5
class Car11 {
	// public _speed: number = 0; // Default
	private _speed: number = 0; // Default
	constructor (readonly wheels: number, readonly power: number)
	{}
	get speed(): number {
		return this._speed;
	}
	set speed(newSpeed: number) {
		if (newSpeed && newSpeed > -30 && newSpeed <= 150) {
			this._speed = newSpeed;
		}
	}
	accelerate(time: number) {
		this.speed = this.speed + 0.5*this.power*time;
	}
}
let myCar11 = new Car11(4,20);
console.log(myCar11.speed); // 0
myCar11.speed = 100;
console.log(myCar11.speed); // 100
myCar11.speed = 151;
console.log(myCar11.speed); // 100
// myCar11._speed = 151; // Error, _speed is private and only accessible within class Car11
```

5. `static` member in class

```javascript
// Static member in class - visible on class itself rather than its instances
// Useful for data and behaviour that does not change depending on instances

class Car12 {
	private speed: number = 0; // Default
	static count: number = 0;
	constructor (readonly wheels: number, readonly power: number) {
		Car12.count += 1;
	}
	accelerate(time: number) {
		this.speed = this.speed + 0.5*this.power*time;
	}
}

for (let i = 0; i < 10; i++) {
	new Car12(4,20);
}

console.log(Car12.count); //
```

6. `Abstract` class

```javascript
// Abstract classes allow to create base classes from which other classed may be derived
// Abstract classes cannot be instantiated themselves, and provides implmentation details

abstract class Vehicle13 {
	wheels: number;
	power: number;
	speed: number = 0; // default
	constructor (wheels: number, power: number) {
		this.wheels = wheels;
		this.power = power;
	}
	abstract accelerate(time: number): void;
}

class Car13 extends Vehicle13 {
	constructor (wheels, power)
	{ super(wheels, power); }
	public accelerate(time: number): void {
		this.speed = this.speed + 0.5*this.power*time;
	}
}

let myCar13 = new Car13(4, 20);
myCar13.accelerate(5);
console.log(myCar13.speed); // 50; 0.5*20*5
// let myVehicle13 = new Vehicle13(4, 20); // Error, cannot create an instance of an abstract class
```

## Use case study

> Typescript class extension in Pulumi Infrastructure-as-code k8s deployment

* Pulumi deployment script `index.js` - import cutomize made `k8sjs` module to extend standard Pulumi k8s deployment class

<details><summary><b>Click to see Typescript code</b></summary><br>

```javascript
// Deploy 3 pods with service definition

import * as pulumi from "@pulumi/pulumi";
import * as k8sjs from "./k8sjs";

const config = new pulumi.Config();

const batch_processor = new k8sjs.ServiceDeployment("batch-processor", {
    image: "nginx:stable",
    env: { QUEUE_NAME: "MyQueue" },
});

const backend = new k8sjs.ServiceDeployment("backend", {
    image: "nginx:stable",
    ports: [8081],
    env: { DB_CONNECTION_STRING: "abcdef…." },
});

const frontend = new k8sjs.ServiceDeployment("frontend", {
    image: "nginx:stable",
    ports: [80],
    allocateIpAddress: true,
    isMinikube: config.getBoolean("isMinikube"),
    env: { BACKEND_URL: "backend:8081" },
    // replicas: 2,
});

export let frontendIp = frontend.ipAddress;
```

</details><br>

* `k8sjs` module

<details><summary><b>Click to see Typescript code</b></summary><br>

```javascript
// Copyright 2016-2019, Pulumi Corporation.  All rights reserved.

import * as k8s from "@pulumi/kubernetes";
import * as k8stypes from "@pulumi/kubernetes/types/input";
import * as pulumi from "@pulumi/pulumi";

/**
 * ServiceDeployment is an example abstraction that uses a class to fold together the common pattern of a
 * Kubernetes Deployment and its associated Service object.
 */
export class ServiceDeployment extends pulumi.ComponentResource { // Extend imported pulumi.ComponentResources class
    public readonly deployment: k8s.apps.v1.Deployment; // Public and readonly property
    public readonly service: k8s.core.v1.Service; // Public and readonly property
    public readonly ipAddress?: pulumi.Output<string>; // Public and readonly property

    constructor(name: string, args: ServiceDeploymentArgs, opts?: pulumi.ComponentResourceOptions) {
        super("k8sjs:service:ServiceDeployment", name, {}, opts);

        const labels = { app: name }; // Add labels in extension
        const container: k8stypes.core.v1.Container = { // Add container in extension
            name,
            image: args.image,
            resources: args.resources || { requests: { cpu: "100m", memory: "100Mi" } },
            env: [{ name: "GET_HOSTS_FROM", value: "dns" }],
            ports: args.ports && args.ports.map(p => ({ containerPort: p })),
        };
        this.deployment = new k8s.apps.v1.Deployment(name, { // Add deployment spec in extension
            spec: {
                selector: { matchLabels: labels },
                replicas: args.replicas || 1,
                template: {
                    metadata: { labels: labels },
                    spec: { containers: [ container ] },
                },
            },
        }, { parent: this });

	// Skip service resource creating when port number not defined in service definition
        if (args.ports) { // Check deployment argument input and deploy k8s service to associate this deployment
        this.service = new k8s.core.v1.Service(name, {
            metadata: {
                name: name,
                labels: this.deployment.metadata.labels,
            },
            spec: {
                ports: args.ports && args.ports.map(p => ({ port: p, targetPort: p })),
                selector: this.deployment.spec.template.metadata.labels,
                // Minikube does not implement services of type `LoadBalancer`; require the user to specify if we're
                // running on minikube, and if so, create only services of type ClusterIP.
                type: args.allocateIpAddress ? (args.isMinikube ? "ClusterIP" : "LoadBalancer") : undefined,
            },
        }, { parent: this });
        }

        if (args.allocateIpAddress) { // Assign ipAddress variable on conditional deployment argument input
            this.ipAddress = args.isMinikube ?
                this.service.spec.clusterIP :
                this.service.status.loadBalancer.ingress[0].ip;
        }
    }
}

export interface ServiceDeploymentArgs {
    env: string[];
    image: string;
    resources?: k8stypes.core.v1.ResourceRequirements;
    replicas?: number;
    ports?: number[];
    allocateIpAddress?: boolean;
    isMinikube?: boolean;
}
```
</details><br>


