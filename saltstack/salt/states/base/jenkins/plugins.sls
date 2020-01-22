{% set jenkins_dir_home = salt['pillar.get']('jenkins:config:dir:home') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_update_src = salt['pillar.get']('jenkins:config:plugins:updates_source') %}
{% set jenkins_plugins = salt['pillar.get']('jenkins:config:plugins:installed') %}
{% set jenkins_update_timeout = salt['pillar.get']('jenkins:config:plugins:timeout') %}

{% set timeout = 360 %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

{% set plugin_cache = "{0}/updates/default.json".format(jenkins_dir_home) %}

jenkins_updates_file:
  file.directory:
    - name: {{ "{0}/updates".format(jenkins_dir_home) }}
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755
    - require:
      - service: jenkins_service

  pkg.installed:
    - name: curl

  cmd.run:
    - unless: test -f {{ plugin_cache }}
    - name: "curl -L {{ jenkins_update_src }} | sed '1d;$d' > {{ plugin_cache }}"
    - require:
      - pkg: jenkins_updates_file
      - file: jenkins_updates_file

{% for plugin in jenkins_plugins %}
jenkins_install_plugin_{{ plugin }}:
  cmd.run:
    - unless: {{ jenkins_cli }} list-plugins | grep -w {{ plugin }}
    - name: {{ jenkins_cli }} install-plugin {{ plugin }}
    - timeout: {{ jenkins_update_timeout }}
    - require:
      - cmd: jenkins_updates_file
      - cmd: jenkins_serving
    - watch_in:
      - cmd: plugins_restart_jenkins
{% endfor %}

plugins_restart_jenkins:
  cmd.wait:
    - name: "{{ jenkins_cli }} safe-restart"
    - watch_in:
      - cmd: plugins_jenkins_serving

plugins_jenkins_serving:
  cmd.wait:
    - name: "until (curl -I -L {{ jenkins_url }}/jnlpJars/jenkins-cli.jar | grep \"Content-Type: application/java-archive\"); do sleep 1; done"
    - timeout: {{ timeout }}

#plugins:
#  cmd.run:
#    - name: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.instance.pluginManager.plugins.each { println("${it.shortName} - ${it.version}") };'
#    - watch:
#      - cmd: plugins_jenkins_responding