#!/bin/bash

for template in $(ls -1 *.json); do
  echo $template
  packer validate --only=vmware-iso --only=virtualbox-iso $template
done
