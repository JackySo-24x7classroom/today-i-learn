# Markdown tips - Links in code blocks

🔧 **Technologies & Tools:**
![](https://img.shields.io/badge/Technology-Markdown-informational?style=flat&color=2bbc8a)

***Original code block***

```
$  tree cnk-lp-solution-1
cnk-lp-solution-1
├── api
│   ├── openapi.yaml
│   ├── postman
│   │   ├── sample_environments
│   │   │   ├── SecurityNewsSource - Ingress.postman_environment.json
│   │   │   └── SecurityNewsSource - Port Forward.postman_environment.json
│   │   └── SecurityNewsSource.postman_collection.json
│   ├── README.md
│   └── sns-api.html
├── diagrams
│   ├── Milestone1-End.png
│   └── Milestone1-Start.png
├── k8s
│   └── manifests
│ link-in-code-block.md      ├── kustomization.yaml
│       ├── ns.yaml
│       ├── payment.yaml
│       ├── redis.yaml
│       └── secrets
│           ├── redis.conf
│           └── redis_password
├── payments
│   ├── config
│   │   ├── config.development.json
│   │   ├── config.production.json
│   │   └── index.js
│   ├── controllers
│   │   ├── index.js
│   │   ├── PaymentsController.js
│   │   ├── ProbesController.js
│   │   └── Validation.js
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   ├── domain
│   │   └── PaymentDetails.js
│   ├── package.json
│   ├── package-lock.json
│   ├── repositories
│   │   ├── index.js
│   │   └── PaymentsRepository.js
│   └── server.js
├── README.md
└── SOLUTION.md

12 directories, 31 files
```

***Links***

* [README.md][README.md]
* [SOLUTION.md][SOLUTION.md]

***Links in code block***

<pre>
$  tree cnk-lp-solution-1
cnk-lp-solution-1
├── api
│   ├── openapi.yaml
│   ├── postman
│   │   ├── sample_environments
│   │   │   ├── SecurityNewsSource - Ingress.postman_environment.json
│   │   │   └── SecurityNewsSource - Port Forward.postman_environment.json
│   │   └── SecurityNewsSource.postman_collection.json
│   ├── README.md
│   └── sns-api.html
├── diagrams
│   ├── Milestone1-End.png
│   └── Milestone1-Start.png
├── k8s
│   └── manifests
│       ├── kustomization.yaml
│       ├── ns.yaml
│       ├── payment.yaml
│       ├── redis.yaml
│       └── secrets
│           ├── redis.conf
│           └── redis_password
├── payments
│   ├── config
│   │   ├── config.development.json
│   │   ├── config.production.json
│   │   └── index.js
│   ├── controllers
│   │   ├── index.js
│   │   ├── PaymentsController.js
│   │   ├── ProbesController.js
│   │   └── Validation.js
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   ├── domain
│   │   └── PaymentDetails.js
│   ├── package.json
│   ├── package-lock.json
│   ├── repositories
│   │   ├── index.js
│   │   └── PaymentsRepository.js
│   └── server.js
├── <a href="deliverable/cnk-lp-solution-1/README.md">README.md</a>
└── <a href="deliverable/cnk-lp-solution-1/SOLUTION.md">SOLUTION.md</a>

12 directories, 31 files
</pre>

<details><summary><i>Click to show code</i></summary><br>

```html
<pre>
$  tree cnk-lp-solution-1
cnk-lp-solution-1
├── api
│   ├── openapi.yaml
│   ├── postman
│   │   ├── sample_environments
│   │   │   ├── SecurityNewsSource - Ingress.postman_environment.json
│   │   │   └── SecurityNewsSource - Port Forward.postman_environment.json
│   │   └── SecurityNewsSource.postman_collection.json
│   ├── README.md
│   └── sns-api.html
├── diagrams
│   ├── Milestone1-End.png
│   └── Milestone1-Start.png
├── k8s
│   └── manifests
│       ├── kustomization.yaml
│       ├── ns.yaml
│       ├── payment.yaml
│       ├── redis.yaml
│       └── secrets
│           ├── redis.conf
│           └── redis_password
├── payments
│   ├── config
│   │   ├── config.development.json
│   │   ├── config.production.json
│   │   └── index.js
│   ├── controllers
│   │   ├── index.js
│   │   ├── PaymentsController.js
│   │   ├── ProbesController.js
│   │   └── Validation.js
│   ├── docker-entrypoint.sh
│   ├── Dockerfile
│   ├── domain
│   │   └── PaymentDetails.js
│   ├── package.json
│   ├── package-lock.json
│   ├── repositories
│   │   ├── index.js
│   │   └── PaymentsRepository.js
│   └── server.js
├── <a href="deliverable/cnk-lp-solution-1/README.md">README.md</a>
└── <a href="deliverable/cnk-lp-solution-1/SOLUTION.md">SOLUTION.md</a>

12 directories, 31 files
</pre>
```

</details><br>

[README.md]: deliverable/cnk-lp-solution-1/README.md
[SOLUTION.md]: deliverable/cnk-lp-solution-1/SOLUTION.md
