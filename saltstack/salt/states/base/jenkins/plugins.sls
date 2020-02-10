{% set jenkins_dir_home = salt['pillar.get']('jenkins:config:dir:home') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_update_src = salt['pillar.get']('jenkins:config:plugins:updates_source') %}
{% set jenkins_plugins = salt['pillar.get']('jenkins:config:plugins:installed') %}
{% set jenkins_update_tout = salt['pillar.get']('jenkins:config:plugins:timeout') %}

{% set timeout = 360 %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

{% set plugin_cache = "{0}/updates/default.json".format(jenkins_dir_home) %}
{% set plugin_path = "{0}/plugins/".format(jenkins_dir_home) %}

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

export_plugin_list:
  cmd.run:
    - unless: {{ jenkins_cli }} list-plugins | awk '{if(substr($NF, length($NF))==")") print $1":"$(NF - 1) ; else print $1":"$NF}' > /tmp/jenkins_pluginlist.txt

{% for plugin in jenkins_plugins %}
{% set plugin_name = plugin.split(':')[0] %}
{% set plugin_version = plugin.split(':')[1] %}

{% set jenkins_update_timeout = jenkins_update_tout %}
{% if 'aws-java-sdk' in plugin_name %}
    {%- set jenkins_update_timeout = 300 %}
{% endif %}

jenkins_install_plugin_{{ plugin }}:
  cmd.run:
    - unless: grep -w '{{ plugin }}' /tmp/jenkins_pluginlist.txt
    - name: {{ jenkins_cli }} install-plugin http://updates.jenkins-ci.org/download/plugins/{{ plugin_name }}/{{ plugin_version }}/{{ plugin_name }}.hpi
    - timeout: {{ jenkins_update_timeout }}
    - require:
      - cmd: export_plugin_list
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