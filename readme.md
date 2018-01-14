# Ansible Playbook Jvcdp Devops CDP infrastrucure using Docker and Ansible

This playbook is for devops cdp. It performs following tasks (non-exhaustive list) on the target servers:

1. Download Prerequisites
  1. Docker
  2. Dockercompose
  3. Docker-py
  4. Boto3 etc...
2. Downloads the latest artifacts from the s3 repository
3. Builds all the container images with latest artifacts
4. Executes the containers and orchestrates them (the images are not yet uploaded to hub/container registry.)
5. Recreates the docker network for containers to interact according to endpoints/ports 
and other related tasks...