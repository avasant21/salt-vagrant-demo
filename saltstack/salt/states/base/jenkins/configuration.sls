# Parameterized Remote Trigger
{% set param_remote_display_name = salt['pillar.get']('jenkins:config:parameteried_remote_trigger:display_name') %}
{% set param_remote_url = salt['pillar.get']('jenkins:config:parameteried_remote_trigger:remote_url') %}
{% set param_remote_username = salt['pillar.get']('jenkins:config:parameteried_remote_trigger:username') %}
{% set param_remote_apitoken = salt['pillar.get']('jenkins:config:parameteried_remote_trigger:apitoken') %}

# Mailer
{% set mailer_smtphost = salt['pillar.get']('jenkins:config:mailer:smtp_host') %}
{% set mailer_suffix = salt['pillar.get']('jenkins:config:mailer:default_suffix') %}
{% set mailer_smtpport = salt['pillar.get']('jenkins:config:mailer:smtp_port') %}


{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

parameteried_remote_trigger:
    cmd.run:
    - unless: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.getInstance().getDescriptorByType(org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteBuildConfiguration.DescriptorImpl.class).getRemoteSites()[0].getDisplayName()' | grep '{{ param_remote_display_name }}'
    - name: |
        echo "auth = new org.jenkinsci.plugins.ParameterizedRemoteTrigger.auth2.TokenAuth() \n auth.setUserName('{{ param_remote_username }}') \n auth.setApiToken('{{ param_remote_apitoken }}') \n remoteJenkinsServer = new org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteJenkinsServer() \n remoteJenkinsServer.setDisplayName('{{ param_remote_display_name }}') \n remoteJenkinsServer.setAddress('{{ param_remote_url }}') \n remoteJenkinsServer.setAuth2(auth) \n descriptor1 = jenkins.model.Jenkins.instance.getDescriptorByType(org.jenkinsci.plugins.ParameterizedRemoteTrigger.RemoteBuildConfiguration.DescriptorImpl.class) \n descriptor1.setRemoteSites(remoteJenkinsServer) \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service

mailer_config:
  cmd.run:
    - unless: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.getInstance().getDescriptor("hudson.tasks.Mailer").getSmtpHost()' | grep '{{ mailer_smtphost }}'
    - name: |
        echo "jenkins.model.Jenkins.getInstance().getDescriptor('hudson.tasks.Mailer').setSmtpHost('{{ mailer_smtphost }}') \n jenkins.model.Jenkins.getInstance().getDescriptor('hudson.tasks.Mailer').setSmtpPort('{{ mailer_smtpport }}') \n jenkins.model.Jenkins.getInstance().getDescriptor('hudson.tasks.Mailer').setDefaultSuffix('{{ mailer_suffix }}') \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service