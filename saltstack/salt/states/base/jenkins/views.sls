{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

/var/log/jenkins/views_xml:
  file.directory:
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755
    - makedirs: True
    - require:
      - user: jenkins_user
      - group: jenkins_group  

{% for jenkins_view in salt['pillar.get']('views:create') %}
views_xml_{{ jenkins_view }}:
  file.managed:
    - unless: test -f /var/log/jenkins/views_xml/{{ jenkins_view }}.xml
    - name: /var/log/jenkins/views_xml/{{ jenkins_view }}.xml
    - source: salt://jenkins/views/{{ jenkins_view }}.xml
    - require_in:
      - jenkins_view_{{ jenkins_view }}
    - require:
      - cmd: plugins_jenkins_serving

jenkins_view_{{ jenkins_view }}:
  cmd.run:
    - unless: {{ jenkins_cli }} get-view '{{ jenkins_view }}'
    - name: {{ jenkins_cli }} create-view {{ jenkins_view }} < /var/log/jenkins/views_xml/{{ jenkins_view }}.xml
{% endfor %}
