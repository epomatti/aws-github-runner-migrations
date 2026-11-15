#!/bin/bash

set -e

branch="main"
inventory="/opt/company/inventory.ini"
playbooks="/opt/company/playbooks"

if [ -d "$playbooks" ]; then
  git -C "$playbooks" pull --ff-only
else
  GITHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id github_token2 --query SecretString --output text)
  git clone -b $branch https://${GITHUB_TOKEN}@github.com/epomatti/aws-github-runner-migrations.git $playbooks
fi

ansible-playbook -i $inventory -l localhost $playbooks/ansible/local.yaml
