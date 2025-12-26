#!/usr/bin/env bash

apt install -y ubuntu-advantage-tools
pro enable usg

# Seems that USG is already installed, with the Canonical profiles
# apt install -y usg usg-benchmarks-1

USG_CIS_PROFILE=$(aws ssm get-parameter --name usg_cis_profile --query Parameter.Value --with-decryption --output text)
usg fix "$USG_CIS_PROFILE"
