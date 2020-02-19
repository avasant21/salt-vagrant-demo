{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_master_admin = salt['pillar.get']('jenkins:config:master_admin') %}
{% set jenkins_server_name = salt['pillar.get']('jenkins:config:server_name') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_ui_url = salt['pillar.get']('jenkins:config:jenkins_url') %}

{% set timeout = 360 %}

jenkins_serving:
  pkg.installed:
    - name: curl

  cmd.wait:
    - name: "until (curl -I -L {{ jenkins_url }}/jnlpJars/jenkins-cli.jar | grep \"Content-Type: application/java-archive\"); do sleep 1; done"
    - timeout: {{ timeout }}
    - watch:
      - cmd: jenkins_listening
    - require:
      - service: jenkins_service

jenkins_cli_jar:
  cmd.run:
    - unless: test -f {{ jenkins_cli_path }}
    - name: "curl -L -o {{ jenkins_cli_path }} {{ jenkins_url }}/jnlpJars/jenkins-cli.jar"
    - require:
      - cmd: jenkins_serving

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

jenkins_responding:
  cmd.wait:
    - name: "until {{ jenkins_cli }} who-am-i; do sleep 1; done"
    - timeout: {{ timeout }}
    - watch:
      - cmd: jenkins_cli_jar

jenkins_set_url:
  cmd.run:
    - unless: echo 'jenkins.model.JenkinsLocationConfiguration.get().getUrl()' | {{ jenkins_cli }} groovysh | grep '{{ jenkins_server_name }}'
    - name: |
        echo -e 'jenkins.model.JenkinsLocationConfiguration.get().setUrl("{{ jenkins_ui_url }}") \n jenkins.model.JenkinsLocationConfiguration.get().setAdminAddress("{{ jenkins_master_admin }}") \n jenkins.model.Jenkins.instance.setInstallState(jenkins.install.InstallState.INITIAL_SETUP_COMPLETED) \n jenkins.model.Jenkins.instance.save()' | {{ jenkins_cli }} groovysh
    - require:
      - service: jenkins_service
