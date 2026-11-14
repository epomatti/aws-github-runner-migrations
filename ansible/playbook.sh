#!/bin/bash

sudo ansible-playbook -i hosts local.yaml

sudo ansible-pull -i hosts local.yaml