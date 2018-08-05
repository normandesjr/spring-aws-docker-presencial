#!/bin/bash

echo "Installing software on instances:"

echo "Starting ansible..."

ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ../terraform/template/hosts beer-playbook.yml --private-key ../terraform/key/beer_key -v