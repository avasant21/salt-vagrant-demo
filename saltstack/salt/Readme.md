cnMaestro DevOps Jenkins Implementation
---------------------------------------
The below procedure to be followed to deploy the Jenkins environment in on-prem. This folder contains the reciepes to install and configure jenkins with nginx reverse proxy.


# ############################################################################################################

1. Salt Configuration:

jenkins VM/Instance should be configured as salt-masterless and fileroot configuration has to be updated as below.
======================================
cat <<EOT >> /etc/salt/minion
id: jenkins
file_client: local
failhard: True

file_roots:
  base:
    - /srv/salt/states/base/

pillar_roots:
  base:
    - /srv/salt/pillars/base/
EOT
======================================

2. The states and pillars data can be copied by executing the rsync script from below path.

# 2.1. Update "~/.ssh/config" with below. The user and key have to be created from console post the VM creation

Host jenkinstest.cmbnwk.com
  User cambium
  HostName <IP Address>
  IdentityFile ~/.ssh/<cambium_key>

# 2.2. Execute the below to copy the states and pillars

$ ./cnssops/jenkins/salt/rsync-salt-trees.sh

3. Applying Highstate (May take 15 to 20 mins based on number of plugins being installed)

# 3.1. Below sls_id alone to be applied first to make sure the gpgkeys are copied for salt-call to use.

$ salt-call --local state.sls_id salt_gpgkeys linux --retcode-passthrough

# 3.2. The highstate to be applied to configure rest of the nginx and jenkins configuration.

$ salt-call --local state.highstate --retcode-passthrough

4. Salt Environments:

The credential passwords/private keys/tokens to be updated manually by the individuals

# ############################################################################################################


# Salt Detailed configuration:

1. Salt Environments

base

2. Salt Madules & Respective Pillars

 - packages - To Install the requisite packages like java & lvm
 - linux - To create ftpuser home directory and copy the gpg keys 
 - linux.users - To create the Linux OS admin & other users
 - nginx - To install nginx and update the configuration files
 - jenkins - To install and configure the nginx package
 - jenkins.cli - To enable the cli for further salt execution
 - jenkins.plugins - To install and update the plugins
 - jenkins.users - To create/delete users and enable access levels
 - jenkins.jobs - To create / delete jobs (Managed as xml)
 - jenkins.configuration - To perform jenkins basic configurations like publish over ssh/clfs, remote trigger, etc
 - jenkins.views - To create/delete view and add/remove the jobs  (Managed as xml)
 - jenkins.credentials - To import/manage the credentials
