# Markdown tips - Links in code blocks

π§ **Technologies & Tools:**
![](https://img.shields.io/badge/Technology-Markdown-informational?style=flat&color=2bbc8a)

***Original code block***

```
$ ξ° tree cnk-lp-solution-1
cnk-lp-solution-1
βββ api
βΒ Β  βββ openapi.yaml
βΒ Β  βββ postman
βΒ Β  βΒ Β  βββ sample_environments
βΒ Β  βΒ Β  βΒ Β  βββ SecurityNewsSource - Ingress.postman_environment.json
βΒ Β  βΒ Β  βΒ Β  βββ SecurityNewsSource - Port Forward.postman_environment.json
βΒ Β  βΒ Β  βββ SecurityNewsSource.postman_collection.json
βΒ Β  βββ README.md
βΒ Β  βββ sns-api.html
βββ diagrams
βΒ Β  βββ Milestone1-End.png
βΒ Β  βββ Milestone1-Start.png
βββ k8s
βΒ Β  βββ manifests
βΒ link-in-code-block.mdΒ      βββ kustomization.yaml
βΒ Β      βββ ns.yaml
βΒ Β      βββ payment.yaml
βΒ Β      βββ redis.yaml
βΒ Β      βββ secrets
βΒ Β          βββ redis.conf
βΒ Β          βββ redis_password
βββ payments
βΒ Β  βββ config
βΒ Β  βΒ Β  βββ config.development.json
βΒ Β  βΒ Β  βββ config.production.json
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βββ controllers
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βΒ Β  βββ PaymentsController.js
βΒ Β  βΒ Β  βββ ProbesController.js
βΒ Β  βΒ Β  βββ Validation.js
βΒ Β  βββ docker-entrypoint.sh
βΒ Β  βββ Dockerfile
βΒ Β  βββ domain
βΒ Β  βΒ Β  βββ PaymentDetails.js
βΒ Β  βββ package.json
βΒ Β  βββ package-lock.json
βΒ Β  βββ repositories
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βΒ Β  βββ PaymentsRepository.js
βΒ Β  βββ server.js
βββ README.md
βββ SOLUTION.md

12 directories, 31 files
```

***Links***

* [README.md][README.md]
* [SOLUTION.md][SOLUTION.md]

***Links in code block***

<pre>
$ ξ° tree cnk-lp-solution-1
cnk-lp-solution-1
βββ api
βΒ Β  βββ openapi.yaml
βΒ Β  βββ postman
βΒ Β  βΒ Β  βββ sample_environments
βΒ Β  βΒ Β  βΒ Β  βββ SecurityNewsSource - Ingress.postman_environment.json
βΒ Β  βΒ Β  βΒ Β  βββ SecurityNewsSource - Port Forward.postman_environment.json
βΒ Β  βΒ Β  βββ SecurityNewsSource.postman_collection.json
βΒ Β  βββ README.md
βΒ Β  βββ sns-api.html
βββ diagrams
βΒ Β  βββ Milestone1-End.png
βΒ Β  βββ Milestone1-Start.png
βββ k8s
βΒ Β  βββ manifests
βΒ Β      βββ kustomization.yaml
βΒ Β      βββ ns.yaml
βΒ Β      βββ payment.yaml
βΒ Β      βββ redis.yaml
βΒ Β      βββ secrets
βΒ Β          βββ redis.conf
βΒ Β          βββ redis_password
βββ payments
βΒ Β  βββ config
βΒ Β  βΒ Β  βββ config.development.json
βΒ Β  βΒ Β  βββ config.production.json
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βββ controllers
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βΒ Β  βββ PaymentsController.js
βΒ Β  βΒ Β  βββ ProbesController.js
βΒ Β  βΒ Β  βββ Validation.js
βΒ Β  βββ docker-entrypoint.sh
βΒ Β  βββ Dockerfile
βΒ Β  βββ domain
βΒ Β  βΒ Β  βββ PaymentDetails.js
βΒ Β  βββ package.json
βΒ Β  βββ package-lock.json
βΒ Β  βββ repositories
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βΒ Β  βββ PaymentsRepository.js
βΒ Β  βββ server.js
βββ <a href="deliverable/cnk-lp-solution-1/README.md">README.md</a>
βββ <a href="deliverable/cnk-lp-solution-1/SOLUTION.md">SOLUTION.md</a>

12 directories, 31 files
</pre>

<details><summary><i>Click to show code</i></summary><br>

```html
<pre>
$ ξ° tree cnk-lp-solution-1
cnk-lp-solution-1
βββ api
βΒ Β  βββ openapi.yaml
βΒ Β  βββ postman
βΒ Β  βΒ Β  βββ sample_environments
βΒ Β  βΒ Β  βΒ Β  βββ SecurityNewsSource - Ingress.postman_environment.json
βΒ Β  βΒ Β  βΒ Β  βββ SecurityNewsSource - Port Forward.postman_environment.json
βΒ Β  βΒ Β  βββ SecurityNewsSource.postman_collection.json
βΒ Β  βββ README.md
βΒ Β  βββ sns-api.html
βββ diagrams
βΒ Β  βββ Milestone1-End.png
βΒ Β  βββ Milestone1-Start.png
βββ k8s
βΒ Β  βββ manifests
βΒ Β      βββ kustomization.yaml
βΒ Β      βββ ns.yaml
βΒ Β      βββ payment.yaml
βΒ Β      βββ redis.yaml
βΒ Β      βββ secrets
βΒ Β          βββ redis.conf
βΒ Β          βββ redis_password
βββ payments
βΒ Β  βββ config
βΒ Β  βΒ Β  βββ config.development.json
βΒ Β  βΒ Β  βββ config.production.json
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βββ controllers
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βΒ Β  βββ PaymentsController.js
βΒ Β  βΒ Β  βββ ProbesController.js
βΒ Β  βΒ Β  βββ Validation.js
βΒ Β  βββ docker-entrypoint.sh
βΒ Β  βββ Dockerfile
βΒ Β  βββ domain
βΒ Β  βΒ Β  βββ PaymentDetails.js
βΒ Β  βββ package.json
βΒ Β  βββ package-lock.json
βΒ Β  βββ repositories
βΒ Β  βΒ Β  βββ index.js
βΒ Β  βΒ Β  βββ PaymentsRepository.js
βΒ Β  βββ server.js
βββ <a href="deliverable/cnk-lp-solution-1/README.md">README.md</a>
βββ <a href="deliverable/cnk-lp-solution-1/SOLUTION.md">SOLUTION.md</a>

12 directories, 31 files
</pre>
```

</details><br>

[README.md]: deliverable/cnk-lp-solution-1/README.md
[SOLUTION.md]: deliverable/cnk-lp-solution-1/SOLUTION.md
