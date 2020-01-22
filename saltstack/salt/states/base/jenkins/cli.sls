{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}

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

restart_jenkins:
  cmd.wait:
    - name: "{{ jenkins_cli }} safe-restart"
    - require:
      - cmd: jenkins_cli_jar

reload_jenkins_config:
  cmd.wait:
    - name: "{{ jenkins_cli }} reload-configuration"
    - require:
      - cmd: jenkins_cli_jar

jenkins_responding:
  cmd.wait:
    - name: "until {{ jenkins_cli }} who-am-i; do sleep 1; done"
    - timeout: {{ timeout }}
    - watch:
      - cmd: jenkins_cli_jar
    - require: 
      - cmd: reload_jenkins_config
      - cmd: restart_jenkins