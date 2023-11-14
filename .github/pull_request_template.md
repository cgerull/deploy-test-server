<!--- Provide a general summary of your changes in the Title above. -->
<!--- If you're deploying a new version of the application specify the chart name, image versions and environment, e.g.: -->
<!--- "Deploy testserver 1.2.3 to dev-local" -->
<!--- If you're deploying changes to database and application, include that: -->
<!--- "Deploy mysql 1.2.3 and testserver 2.2.2 to dev" -->

## Description
<!--- If you are deploying a version of an application you can remove this section. -->

<!--- If you are not deploying a version of an application, describe the purpose of this PR in detail. There should be enough -->
<!--- detail for a reviewer to read the text and know why you created a pull reques before looking at the code. Where possible -->
<!--- reference the JIRA ticket number, this repository is configured to auto-link TS-xxxx to Jira tickets. -->

## Types of changes
<!--- What types of changes does your code introduce? You should pick one, if you pick multiple maybe you need to create a -->
<!--- separate pull request. -->
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)

<!--- Delete the rest of the text if you are not deploying a version of an application -->
## Deployment Checklist:
This pull request should only be approved when all below checks have been completed.

<!--- Delete the checklists that do not apply -->
### Deploying to Dev / Test
- [ ] New Rabbit MQ queues need to be configured
- [ ] Required RabbitMQ config is in place <!--- Check this box if no changes are required, that shows it has been checked -->
- [ ] New MinIO bucket needed <!--- Delete this if not deploying MinIO -->

### Deploying to ACC
- [ ] Release has been tested in test
- [ ] Approved JIRA change ticket: TS-xxxx <!--- Replace TS-xxxx with the JIRA ticket number -->
- [ ] Required RabbitMQ config is in place <!--- Check this box if no changes are required, that shows it has been checked -->
- [ ] Required MinIO config is in place <!--- Delete this if not deploying MinIO -->

### Deploying to PROD
- [ ] Release has been tested in acceptance
- [ ] Approved JIRA change ticket: TS-xxxx <!--- Replace TS-xxxx with the JIRA ticket number -->
- [ ] Required RabbitMQ config is in place <!--- Check this box if no changes are required, that shows it has been checked -->
- [ ] Required MinIO config is in place <!--- Delete this if not deploying MinIO -->
