# Learn Typescript Interfaces

<img width=80% src="images/IMG_3454.JPG" align="center">

`Table of Content`
<!-- vim-markdown-toc GFM -->

- [Learn interfaces](#learn-interfaces)
- [Use case in Pulumi IaC](#use-case-in-pulumi-iac)

<!-- vim-markdown-toc -->

## Learn interfaces

> How to create and use interfaces with Typescript

> In addition, learn how to:

* Use inheritance with interfaces
* Do excess property checks

1. Learn interfaces

```javascript
// Interfaces behave like contracts: When we sign(implement) it, we have to follow its rules
// Interfaces likes abstract classes with (only) abstract methods and properties, and no actual data or code within

// Interfaces are duck typed(or structured subtyped)
// Compiler simply checks we have at least required member

interface Car {
	speed: number;
	power: number;
}

function parkCar(car: Car) {
	car.speed = 0;
	console.log(`Car is parked`);
}

parkCar({speed: 50, power: 200});
```

2. Optional properties

```javascript
// Sometimes, we may have property that is optional

interface Car1 {
	speed: number;
	fluxCapacitor?: boolean;
	powerOutput?: number;
}

function timeTravel(car: Car1) {
	if (car.fluxCapacitor && car.powerOutput >= 1.21) {
		car.speed = 88;
		console.log(`Travelling to 1955`)
	}
	console.log(car.speed);
}

timeTravel({
	speed: 50,
	fluxCapacitor: false, // Travelling to 1955 not shown and speed: 50
	// fluxCapacitor: true, // Travelling to 1955 shown and speed: 88
	// powerOutput: 1.20 // Travelling to 1955 not shown and speed: 50
	powerOutput: 1.21
});
```
3. Property checks

```javascript
// Excess property checks
/* 
 * To override, we can use either
 * - Use type assertion
 * - Add a type index signature
 * - Assign to a variable first
 */

// Function Types
// Interfaces can describe wide range of shapes that Javascript objects can take, including functions,
// and name of parameter in the implementation need not match th ename in the interface

interface Log {
	(error: string): void;
}

let logError: Log = function(err: string) { // function use err, not match error in interface
	console.log(err)
}

logError(`Hello, testing`);

// Describe types in index
interface GarageArray {
	[index: number]: string;
}

let myGarage: GarageArray = [
	`Ford Fiesta`,
	`Audi A3`,
	`Toyota Prius`
]

console.log(myGarage);

// You can use both string and number indexers, but type returned from number indexers must be a subtype of the type returned from the string indexer
// because myGarage[1] === myGarage["1"]

interface GarageArray1 {
	[index: string]: number;
}

let myGarage1: GarageArray1 = {
	"Ford Fiesta": 1,
	"Audi A3": 2,
	"Toyota Prius": 4
}

console.log(myGarage1["Ford Fiesta"]);
```

4. Meet contract

```javascript
// Ensuring class meets a particular contract, we define both properties and method

interface Car2 {
	power: number;
	speed: number;
	accelerate(t: number): void;
}

class FastCar2 implements Car2 {
	speed: number = 0;
	constructor(public power: number) {}

	accelerate(time: number): void {
		this.speed = this.speed + 0.5*this.power*time
	}
}
let myCar2 = new FastCar2(20);
myCar2.accelerate(10);
console.log(myCar2.speed) // 100; = 0.5 * 20 * 10
```

5. Extend Interfaces

```javascript
// Classes can extend multiple interfaces - fine control over reuseable compoments

interface Vehicle10 {
	wheels: number;
	color: string;
}

interface Car10 extends Vehicle10 {
	power: number;
	speed: number;
	accelerate(t: number): void;
}

class FastCar10 implements Car10 {
	speed: number = 0; // Default
	wheels: number = 4; // Default
	constructor(
		// public wheels: number = 4, // Default wheels
		public power: number,
		public color: string)
		{}

	accelerate(time: number): void {
		this.speed = this.speed + 0.5*this.power*time
	}
}

// let myCar10 = new Car10(200, `red`); // Car10 is only refers to a type
// let myCar10 = new FastCar10(4, 200, `red`); // Car10 is only refers to a type
let myCar10 = new FastCar10(200, `red`); // Car10 is only refers to a type
let wheelorder: number = myCar10.wheels + 1;
myCar10.accelerate(5);
console.log(wheelorder, myCar10.color, myCar10.speed) // 5, red, 500; = 0.5 * 200 * 5

```

## Use case in Pulumi IaC

> Use interfaces to come up k8s deployment input array in Pulumi IaC

* `index.ts` - defining all deployment arguments, including array type environment variable for container

```javascript
// Deploy 2-tier stack in k8s orchestration

import * as pulumi from "@pulumi/pulumi";
import * as k8sm from "./k8sm";

const config = new pulumi.Config();

const backend = new k8sm.ServiceDeployment("backend", {
    image: "nginx:latest",
    ports: [8080],
    env: { DB_CONNECTION_STRING: "mysql:3306" },
});

const frontend = new k8sm.ServiceDeployment("frontend", {
    image: "nginx:latest",
    ports: [80],
    allocateIpAddress: true,
    isMinikube: config.getBoolean("isMinikube"),
    env: { BACKEND_URL: "backend:8080" },
    replicas: 2,
});

export let frontendIp = frontend.ipAddress;
```

* Customized typescript module `k8sm.ts` for `index.ts` use

<details><summary><b>Click to see Typescript code</b></summary><br>

```javascript
import * as k8s from "@pulumi/kubernetes";
import * as k8stypes from "@pulumi/kubernetes/types/input";
import * as pulumi from "@pulumi/pulumi";

/**
 * ServiceDeployment is an example abstraction that uses a class to fold together the common pattern of a
 * Kubernetes Deployment and its associated Service object.
 */
export class ServiceDeployment extends pulumi.ComponentResource {
    public readonly deployment: k8s.apps.v1.Deployment;
    public readonly service: k8s.core.v1.Service;
    public readonly ipAddress?: pulumi.Output<string>;

    constructor(name: string, args: ServiceDeploymentArgs, opts?: pulumi.ComponentResourceOptions) {
        super("k8sjs:service:ServiceDeployment", name, {}, opts);

        const labels = { app: name };
        const container: k8stypes.core.v1.Container = {
            name,
            image: args.image,
            resources: args.resources || { requests: { cpu: "100m", memory: "100Mi" } },
            env: [{ name: Object.keys(args.env)[0], value: Object(args.env)[Object.keys(args.env)[0]] }],
            ports: args.ports && args.ports.map(p => ({ containerPort: p })),
        };
        this.deployment = new k8s.apps.v1.Deployment(name, {
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
        if (args.ports) {
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

        if (args.allocateIpAddress) {
            this.ipAddress = args.isMinikube ?
                this.service.spec.clusterIP :
                this.service.status.loadBalancer.ingress[0].ip;
        }
    }
}

export interface ServiceDeploymentArgs {
    image: string;
    env: { [key: string]: string; }; // key as property number, string type for value
    // env: { [key: string]: any; }; // key as property number, any type for value
    resources?: k8stypes.core.v1.ResourceRequirements;
    replicas?: number;
    ports?: number[];
    allocateIpAddress?: boolean;
    isMinikube?: boolean;
}
```

</details><br>

> Validate typescript script by Pulumi CLI

<pre>
├── index.ts
├── k8sm.ts
├── package.json
├── package-lock.json
├── Pulumi.sre-devops.yaml
├── Pulumi.yaml
└── tsconfig.json
</pre>

```bash
$  pulumi stack ls
NAME        LAST UPDATE  RESOURCE COUNT
sre-devops  n/a          n/a

$  pulumi preview -s sre-devops
Previewing update (sre-devops):
     Type                                 Name                   Plan
 +   pulumi:pulumi:Stack                  sre-devops-sre-devops  create
 +   ├─ k8sjs:service:ServiceDeployment   frontend               create
 +   │  ├─ kubernetes:apps/v1:Deployment  frontend               create
 +   │  └─ kubernetes:core/v1:Service     frontend               create
 +   └─ k8sjs:service:ServiceDeployment   backend                create
 +      ├─ kubernetes:apps/v1:Deployment  backend                create
 +      └─ kubernetes:core/v1:Service     backend                create

Resources:
    + 7 to create
```

> View details for `pulumi preview` to validate typescript exportable interfaces object `ServiceDeploymentArgs`, in partular, argument `env`

```json
$  pulumi stack ls
NAME        LAST UPDATE  RESOURCE COUNT
sre-devops  n/a          n/a
$  pulumi preview -s sre-devops --diff
Previewing update (sre-devops):
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:sre-devops::sre-devops::pulumi:pulumi:Stack::sre-devops-sre-devops]
    + k8sjs:service:ServiceDeployment: (create)
        [urn=urn:pulumi:sre-devops::sre-devops::k8sjs:service:ServiceDeployment::frontend]
    + k8sjs:service:ServiceDeployment: (create)
        [urn=urn:pulumi:sre-devops::sre-devops::k8sjs:service:ServiceDeployment::backend]
        + kubernetes:apps/v1:Deployment: (create)
            [urn=urn:pulumi:sre-devops::sre-devops::k8sjs:service:ServiceDeployment$kubernetes:apps/v1:Deployment::frontend]
            [provider=urn:pulumi:sre-devops::sre-devops::pulumi:providers:kubernetes::default_3_5_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
            apiVersion: "apps/v1"
            kind      : "Deployment"
            metadata  : {
                annotations: {
                    pulumi.com/autonamed: "true"
                }
                labels     : {
                    app.kubernetes.io/managed-by: "pulumi"
                }
                name       : "frontend-tv1wgydv"
            }
            spec      : {
                replicas: 2
                selector: {
                    matchLabels: {
                        app: "frontend"
                    }
                }
                template: {
                    metadata: {
                        labels: {
                            app: "frontend"
                        }
                    }
                    spec    : {
                        containers: [
                            [0]: {
                                env      : [
                                    [0]: {
                                        name : "BACKEND_URL"
                                        value: "backend:8080"
                                    }
                                ]
                                image    : "nginx:stable"
                                name     : "frontend"
                                ports    : [
                                    [0]: {
                                        containerPort: 80
                                    }
                                ]
                                resources: {
                                    requests: {
                                        cpu   : "100m"
                                        memory: "100Mi"
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        + kubernetes:apps/v1:Deployment: (create)
            [urn=urn:pulumi:sre-devops::sre-devops::k8sjs:service:ServiceDeployment$kubernetes:apps/v1:Deployment::backend]
            [provider=urn:pulumi:sre-devops::sre-devops::pulumi:providers:kubernetes::default_3_5_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
            apiVersion: "apps/v1"
            kind      : "Deployment"
            metadata  : {
                annotations: {
                    pulumi.com/autonamed: "true"
                }
                labels     : {
                    app.kubernetes.io/managed-by: "pulumi"
                }
                name       : "backend-n4l3679y"
            }
            spec      : {
                replicas: 1
                selector: {
                    matchLabels: {
                        app: "backend"
                    }
                }
                template: {
                    metadata: {
                        labels: {
                            app: "backend"
                        }
                    }
                    spec    : {
                        containers: [
                            [0]: {
                                env      : [
                                    [0]: {
                                        name : "DB_CONNECTION_STRING"
                                        value: "mysql:3306"
                                    }
                                ]
                                image    : "nginx:stable"
                                name     : "backend"
                                ports    : [
                                    [0]: {
                                        containerPort: 8080
                                    }
                                ]
                                resources: {
                                    requests: {
                                        cpu   : "100m"
                                        memory: "100Mi"
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        + kubernetes:core/v1:Service: (create)
            [urn=urn:pulumi:sre-devops::sre-devops::k8sjs:service:ServiceDeployment$kubernetes:core/v1:Service::backend]
            [provider=urn:pulumi:sre-devops::sre-devops::pulumi:providers:kubernetes::default_3_5_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
            apiVersion: "v1"
            kind      : "Service"
            metadata  : {
                labels: {
                    app.kubernetes.io/managed-by: "pulumi"
                }
                name  : "backend"
            }
            spec      : {
                ports   : [
                    [0]: {
                        port      : 8080
                        targetPort: 8080
                    }
                ]
                selector: {
                    app: "backend"
                }
            }
        + kubernetes:core/v1:Service: (create)
            [urn=urn:pulumi:sre-devops::sre-devops::k8sjs:service:ServiceDeployment$kubernetes:core/v1:Service::frontend]
            [provider=urn:pulumi:sre-devops::sre-devops::pulumi:providers:kubernetes::default_3_5_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
            apiVersion: "v1"
            kind      : "Service"
            metadata  : {
                labels: {
                    app.kubernetes.io/managed-by: "pulumi"
                }
                name  : "frontend"
            }
            spec      : {
                ports   : [
                    [0]: {
                        port      : 80
                        targetPort: 80
                    }
                ]
                selector: {
                    app: "frontend"
                }
                type    : "LoadBalancer"
            }
Resources:
    + 7 to create
```
