#!/bin/bash

# This script will push the current salt trees directly to the MoM and 
# Bastion machines. A log of the push will be stored on each machine in 
# /srv/log/salt_update file.
#
# Note you must have entries in your ~/.ssh/config directory for the
#  hostnames used below. Please configure any keys/proxies there.

SALT_TREE=../salt/
DEST_TREE=/srv/salt
EXCLUDE_TREE="--exclude=Readme.md --exclude=rsync-salt-trees.sh"
US_MOM_HOST=jenkinstest.cmbnwk.com

echo -e "\nUpdating jenkins masterless salt environment states."
../../scripts/shared/rsync-tree.sh -h ${US_MOM_HOST} -s ${SALT_TREE} -d ${DEST_TREE} -x "${EXCLUDE_TREE}" -l "Update salt tree"
