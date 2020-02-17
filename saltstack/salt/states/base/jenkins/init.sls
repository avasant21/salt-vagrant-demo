{% set jenkins_port = salt['pillar.get']('jenkins:config:jenkins_port') %}
{% set jenkins_dir_home = salt['pillar.get']('jenkins:config:dir:home') %}
{% set jenkins_dir_log = salt['pillar.get']('jenkins:config:dir:log') %}
{% set jenkins_dir_cache = salt['pillar.get']('jenkins:config:dir:cache') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_additional_group = salt['pillar.get']('jenkins:config:additional_groups') %}
{% set jenkins_pkgs = salt['pillar.get']('jenkins:config:pkgs') %}

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
    - name: deb http://pkg.jenkins-ci.org/debian binary/
    - key_url: http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key
    - require_in:
      - pkg: jenkins_pkg

{% for pkg, args in jenkins_pkgs.items() %}
{{ pkg }}_pkg:
  pkg.installed:
    - name: {{ pkg }}
    - version: {{ args['version'] }}
{% endfor %}

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
      - pkg: jenkins_pkg
    - watch:
      - service: jenkins_service