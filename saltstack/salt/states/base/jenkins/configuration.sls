# Parameterized Remote Trigger
{% set param_remote_display_name = salt['pillar.get']('configuration:parameteried_remote_trigger:display_name') %}
{% set param_remote_url = salt['pillar.get']('configuration:parameteried_remote_trigger:remote_url') %}
{% set param_remote_username = salt['pillar.get']('configuration:parameteried_remote_trigger:username') %}
{% set param_remote_apitoken = salt['pillar.get']('configuration:parameteried_remote_trigger:apitoken') %}

# Mailer
{% set mailer_smtphost = salt['pillar.get']('configuration:mailer:smtp_host') %}
{% set mailer_suffix = salt['pillar.get']('configuration:mailer:default_suffix') %}
{% set mailer_smtpport = salt['pillar.get']('configuration:mailer:smtp_port') %}


{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

parameteried_remote_trigger:
    cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getDescriptorByType(org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteBuildConfiguration.DescriptorImpl.class).getRemoteSites()[0].getDisplayName()' | {{ jenkins_cli }} groovysh | grep '{{ param_remote_display_name }}'
    - name: |
        echo -e "auth = new org.jenkinsci.plugins.ParameterizedRemoteTrigger.auth2.TokenAuth() \n auth.setUserName('{{ param_remote_username }}') \n auth.setApiToken('{{ param_remote_apitoken }}') \n remoteJenkinsServer = new org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteJenkinsServer() \n remoteJenkinsServer.setDisplayName('{{ param_remote_display_name }}') \n remoteJenkinsServer.setAddress('{{ param_remote_url }}') \n remoteJenkinsServer.setAuth2(auth) \n descriptor1 = jenkins.model.Jenkins.instance.getDescriptorByType(org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteBuildConfiguration.DescriptorImpl.class) \n descriptor1.setRemoteSites(remoteJenkinsServer) \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service

mailer_config:
  cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getDescriptor("hudson.tasks.Mailer").getSmtpHost()' | {{ jenkins_cli }} groovysh | grep '{{ mailer_smtphost }}'
    - name: |
        echo -e "jenkins.model.Jenkins.instance.getDescriptor('hudson.tasks.Mailer').setSmtpHost('{{ mailer_smtphost }}') \n jenkins.model.Jenkins.instance.getDescriptor('hudson.tasks.Mailer').setSmtpPort('{{ mailer_smtpport }}') \n jenkins.model.Jenkins.instance.getDescriptor('hudson.tasks.Mailer').setDefaultSuffix('{{ mailer_suffix }}') \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service

mail_ext_config:
  cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getDescriptor("hudson.plugins.emailext.ExtendedEmailPublisher").getSmtpServer()' | {{ jenkins_cli }} groovysh | grep '{{ mailer_smtphost }}'
    - name: |
        echo -e "jenkins.model.Jenkins.instance.getDescriptor('hudson.plugins.emailext.ExtendedEmailPublisher').setSmtpServer('{{ mailer_smtphost }}') \n jenkins.model.Jenkins.instance.getDescriptor('hudson.plugins.emailext.ExtendedEmailPublisher').setSmtpPort('{{ mailer_smtpport }}') \n jenkins.model.Jenkins.instance.getDescriptor('hudson.plugins.emailext.ExtendedEmailPublisher').setDefaultSuffix('{{ mailer_suffix }}') \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service

# Publish Over SSH
{% set possh_cc_encryptedPassphrase = salt['pillar.get']('configuration:publish_over_ssh:common_config:encryptedphrase') %}
{% set possh_cc_key = salt['pillar.get']('configuration:publish_over_ssh:common_config:key') %}
{% set possh_cc_key_path = salt['pillar.get']('configuration:publish_over_ssh:common_config:keypath') %}

publish_over_ssh_common_config:
  cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getDescriptor(jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin).getCommonConfig().getKeyPath()' | {{ jenkins_cli }} groovysh | grep -w '{{ possh_cc_key_path }}'
    - name: |
        echo -e "jenkins.model.Jenkins.instance.getDescriptor(jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin).setCommonConfig(new jenkins.plugins.publish_over_ssh.BapSshCommonConfiguration('{{ possh_cc_encryptedPassphrase }}', '{{ possh_cc_key }}', '{{ possh_cc_key_path }}', false)) \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service

# Publish Over SSH - SSH Servers
{% for ssh_name, ssh_args in salt['pillar.get']('configuration:publish_over_ssh:ssh_servers', {}).items() %}
publish_over_ssh_server_{{ ssh_name }}:
  cmd.run:
    - unless: echo  'jenkins.model.Jenkins.instance.getDescriptor("jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin").getConfiguration("{{ ssh_name }}").getName()' | {{ jenkins_cli }} groovysh | grep -w '{{ ssh_name }}'
    - name: |
        echo -e "jenkins.model.Jenkins.instance.getDescriptor(jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin).addHostConfiguration(new jenkins.plugins.publish_over_ssh.BapSshHostConfiguration('{{ ssh_name }}', '{{ ssh_args.hostname }}', '{{ ssh_args.ssh_user }}', '', '{{ ssh_args.root_dir }}', 22, 300000, false, '', '', false)) jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service
{% endfor %}

# Publish Over CIFS - CIFS Servers
{% for cifs_name, cifs_args in salt['pillar.get']('configuration:publish_over_cifs:cifs_servers', {}).items() %}
publish_over_ssh_server_{{ cifs_name }}:
  cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getDescriptor("jenkins.plugins.publish_over_cifs.CifsPublisherPlugin").getConfiguration("{{ cifs_name }}").getName()' | {{ jenkins_cli }} groovysh | grep -w '{{ cifs_name }}'
    - name: |
        echo -e "jenkins.model.Jenkins.instance.getDescriptor(jenkins.plugins.publish_over_cifs.CifsPublisherPlugin).addHostConfiguration(new jenkins.plugins.publish_over_cifs.CifsHostConfiguration('{{ cifs_name }}', '{{ cifs_args.hostname }}', '{{ cifs_args.cifs_user }}', '{{ cifs_args.cifs_password }}', '{{ cifs_args.remote_dir }}', 445, 30000, 4194305)) \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service
{% endfor %}

# Set number of executors
number_of_executors:
  cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getNumExecutors()' | {{ jenkins_cli }} groovysh | grep '{{ salt['pillar.get']('configuration:num_of_executors') }}'
    - name: |
        echo -e "jenkins.model.Jenkins.instance.setNumExecutors('{{ salt['pillar.get']('configuration:num_of_executors') }}') \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service