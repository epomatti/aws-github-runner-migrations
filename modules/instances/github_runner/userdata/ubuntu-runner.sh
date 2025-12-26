#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y

apt install -y jq
snap install aws-cli --classic

### GitHub Self-Hosted Runner ###
# Install the GitHub CLI (https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian)
(type -p wget >/dev/null || (apt update && apt install wget -y)) \
	&& mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt update \
	&& apt install gh -y

# Download and extract
directory=/opt/actions-runner
version=2.330.0
mkdir -p "$directory" && cd "$directory"
curl -o "actions-runner-linux-x64-$version.tar.gz" -L "https://github.com/actions/runner/releases/download/v$version/actions-runner-linux-x64-$version.tar.gz"
tar xzf "./actions-runner-linux-x64-$version.tar.gz"

# Allow to run as root
export RUNNER_ALLOW_RUNASROOT="1"

# Install
export GH_TOKEN=$(aws ssm get-parameter --name "github_token" --query Parameter.Value --with-decryption --output text)
RUNNER_TOKEN=$(gh api /repos/epomatti/aws-github-runner-migrations/actions/runners/registration-token --method POST | jq .token -r)
./config.sh --url https://github.com/epomatti/aws-github-runner-migrations --token "$RUNNER_TOKEN" --unattended --name myrunner --labels LABEL1,LABEL2

# Configure as a service, then start
./svc.sh install
./svc.sh start
