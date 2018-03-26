
# spin-reference-component

This reference infrastructure project which demonstrates separately manageable "stacks". It illustrates patterns and practices for infrastructure as code, including automated testing and using pipelines to deliver changes to infrastructure.

Note that this code is not production-ready, although it will hopefully evolve into something that could be used as a template to start new infrastructure projects.

This project uses AWS, Terraform, and [Infrablocks](https://github.com/infrablocks) modules. However, it's intended to illustrate concepts, patterns, and practices applicable to any cloud platform and/or configuration toolset.


## Some terms

- *Stack*: A collection of infrastructure that is defined and changed as a unit. A Stack Definition is a (Terraform) project, a Stack Instance is an instantiation of the project, corresponding to a statefile.
- *Component*: A component of an overall system, it provides a standalone capability. Examples might be identity management, pipeline orchestration, monitoring, etc. Comprised of one or more services.
- *Service*: An application, service, etc. which provides part of the functionality of the component. Note that some of the code here uses the term "Role", but we're planning to deprecate it.
- *DeploymentIdentifier*: Identifier for a stack instance, to distinguish between different deployments of the same stack definition.


## Related projects

- I set this project up using [spin-bootstrap](https://github.com/kief/spin-bootstrap), particularly the remote statefile bucket, and some IAM roles.
- This project uses several [Infrablocks](https://github.com/infrablocks) Terraform modules.


# Structure and content


# Usage

The root folder contains a Makefile which can be used for two main purposes. One purpose is to provision and test local instances of the services, which will by default have the DEPLOYMENT_ID "sandbox". The second purpose is to create delivery infrastructure for the services, including source repositories and delivery pipelines.

| Commands                         | Description          |
|------------------------------|---------------------------|
| make [plan|up|destroy] | Manage local instances of each of the services. |
| make setup-delivery | Create source repositories and pipelines for each of the services. |
| make load-delivery | Load a copy of each service's source into its code repository. Should trigger pipeline runs. |
| make destroy-delivery | Destroy the source repositories and pipelines for each service. |
| make clean | Clean local working files. Leaves any services and infrastructure in place. |

