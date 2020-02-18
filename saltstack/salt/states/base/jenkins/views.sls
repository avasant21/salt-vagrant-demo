{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_views_home ='/var/log/jenkins/views_xml' %}
{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

{{ jenkins_views_home }}:
  file.directory:
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755
    - makedirs: True
    - require:
      - user: jenkins_user
      - group: jenkins_group  

{% for jenkins_view in salt['pillar.get']('views_present') %}
{% if pillar.get('views_absent') and jenkins_view not in pillar.get('views_absent') %}
views_xml_{{ jenkins_view }}:
  file.managed:
    - unless: test -f {{ jenkins_views_home }}/{{ jenkins_view }}.xml
    - name: {{ jenkins_views_home }}/{{ jenkins_view }}.xml
    - source: salt://jenkins/views/{{ jenkins_view }}.xml
    - require_in:
      - jenkins_view_{{ jenkins_view }}
    - require:
      - cmd: plugins_jenkins_serving

create_view_{{ jenkins_view }}:
  cmd.run:
    - unless: {{ jenkins_cli }} get-view '{{ jenkins_view }}'
    - name: {{ jenkins_cli }} create-view {{ jenkins_view }} < {{ jenkins_views_home }}/{{ jenkins_view }}.xml
{% endif %}
{% endfor %}

{% for jenkins_view in salt['pillar.get']('views_absent') %}
{% if jenkins_view %}
delete_view_{{ jenkins_view }}:
  cmd.run:
    - onlyif: {{ jenkins_cli }} get-view '{{ jenkins_view }}'
    - name: {{ jenkins_cli }} delete-view {{ jenkins_view }}
    - require:
      - cmd: plugins_jenkins_serving
{% endif %}
{% endfor %}