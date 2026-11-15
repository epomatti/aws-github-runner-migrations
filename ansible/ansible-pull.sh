#!/bin/bash
set -e

GITHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id github_token2 --query SecretString --output text)
branch="main"
inventory="/opt/company/inventory.ini"
playbooks="/opt/company/playbooks"

git clone -b $branch https://${GITHUB_TOKEN}@github.com/epomatti/aws-github-runner-migrations.git $playbooks
ansible-playbook -i $inventory -l localhost $playbooks/ansible/local.yaml
