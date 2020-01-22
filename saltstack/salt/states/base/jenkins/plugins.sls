{% set jenkins_port = salt['pillar.get']('jenkins:config:jenkins_port') %}
{% set jenkins_dir_home = salt['pillar.get']('jenkins:config:dir:home') %}
{% set jenkins_dir_log = salt['pillar.get']('jenkins:config:dir:log') %}
{% set jenkins_dir_cache = salt['pillar.get']('jenkins:config:dir:cache') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_additional_group = salt['pillar.get']('jenkins:config:additional_groups') %}
{% set jenkins_server = salt['pillar.get']('jenkins:config:server_name') %}
{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_plugins = salt['pillar.get']('jenkins:config:plugins') %}
{% set jenkins_pkgs = salt['pillar.get']('jenkins:config:pkgs') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_update_src = salt['pillar.get']('jenkins:config:plugins:updates_source') %}
{% set jenkins_plugins = salt['pillar.get']('jenkins:config:plugins:installed') %}
{% set jenkins_update_timeout = salt['pillar.get']('jenkins:config:plugins:timeout') %}


{% set timeout = 360 %}

jenkins_group:
  group.present:
    - name: {{ jenkins_group }}
    - system: True

jenkins_user:
  user.present:
    - name: {{ jenkins_user }}
    - groups:
      - {{ jenkins_group }}
      {% for group in jenkins_additional_group -%}
      - {{ group }}
      {% endfor %}
    - system: True
    - home: {{ jenkins_dir_home }}
    - shell: /bin/bash
    - require:
      - group: jenkins_group

{% for dir in [jenkins_dir_cache,jenkins_dir_log,jenkins_dir_home] %}
{{ dir }}:
  file.directory:
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755
    - makedirs: True
    - require:
      - user: jenkins_user
      - group: jenkins_group
{% endfor %}

jenkins_repo:
  pkgrepo.managed:
    - humanname: Jenkins upstream package repository
    - file: /etc/apt/sources.list.d/jenkins-ci.list
    - name: deb http://pkg.jenkins-ci.org/debian-stable binary/
    - key_url: http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key
    - require_in:
      - pkg: jenkins_pkg

jenkins_pkg:
  pkg.installed:
    - pkgs: {{ jenkins_pkgs|json }}

jenkins_service:
  service.running:
    - name: jenkins
    - enable: True
    - watch:
      - pkg: jenkins_pkg
      - file: jenkins_config

jenkins_config:
  file.managed:
    - name: /etc/default/jenkins
    - source: salt://jenkins/files/jenkins.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: jenkins_pkg

jenkins_listening:
  pkg.installed:
    - name: netcat-openbsd
  cmd.wait:
    - name: "until nc -z localhost {{ jenkins_port }}; do sleep 1; done"
    - timeout: 60
    - require:
      - service: jenkins_service
    - watch:
      - service: jenkins_service

jenkins_serving:
  pkg.installed:
    - name: curl

  cmd.wait:
    - name: "until (curl -I -L {{ jenkins_url }}/jnlpJars/jenkins-cli.jar | grep \"Content-Type: application/java-archive\"); do sleep 1; done"
    - timeout: {{ timeout }}
    - watch:
      - cmd: jenkins_listening

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

{% set plugin_cache = "{0}/updates/default.json".format(jenkins_dir_home) %}

jenkins_updates_file:
  file.directory:
    - name: {{ "{0}/updates".format(jenkins_dir_home) }}
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755

  pkg.installed:
    - name: curl

  cmd.run:
    - unless: test -f {{ plugin_cache }}
    - name: "curl -L {{ jenkins_update_src }} | sed '1d;$d' > {{ plugin_cache }}"
    - require:
      - pkg: jenkins_pkg
      - pkg: jenkins_updates_file
      - file: jenkins_updates_file

{% for plugin in jenkins_plugins %}
jenkins_install_plugin_{{ plugin }}:
  cmd.run:
    - unless: {{ jenkins_cli }} list-plugins | grep -w {{ plugin }}
    - name: {{ jenkins_cli }} install-plugin {{ plugin }}
    - timeout: {{ jenkins_update_timeout }}
    - require:
      - service: jenkins_service
      - cmd: jenkins_updates_file
    - watch_in:
      - cmd: restart_jenkins
{% endfor %}