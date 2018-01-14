# Ansible Playbook DevopsCDP

This playbook is for devops cdp. It performs following tasks (non-exhaustive list) on the target servers:

1. Download Prerequisites
  1. Docker
  2. Dockercompose
  3. Docker-py
  4. Boto3
  ....

2. Downloads the latest artifacts from the s3 repository
3. Builds all the images
4. Executes the containers and orchestrates them