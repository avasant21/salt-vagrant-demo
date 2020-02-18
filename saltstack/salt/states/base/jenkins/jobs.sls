{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_jobs_home ='/var/log/jenkins/jobs_xml' %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

{{ jenkins_jobs_home }}:
  file.directory:
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755
    - makedirs: True
    - require:
      - user: jenkins_user
      - group: jenkins_group  

export_jobs_list:
  cmd.run:
    - unless: {{ jenkins_cli }} list-jobs > /tmp/jenkins_joblist.txt

{% for jenkins_job in salt['pillar.get']('jobs_present') %}
{% if pillar.get('jobs_absent') and jenkins_job not in pillar.get('jobs_absent') %}
jobs_xml_{{ jenkins_job }}:
  file.managed:
    - unless: test -f {{ jenkins_jobs_home }}/{{ jenkins_job }}.xml
    - name: {{ jenkins_jobs_home }}/{{ jenkins_job }}.xml
    - source: salt://jenkins/jobs/{{ jenkins_job }}.xml
    - require_in:
      - jenkins_job_{{ jenkins_job }}
    - require:
      - cmd: plugins_jenkins_serving

create_job_{{ jenkins_job }}:
  cmd.run:
    - unless: grep -w '{{ jenkins_job }}' /tmp/jenkins_joblist.txt
    - name: {{ jenkins_cli }} create-job '{{ jenkins_job }}' < {{ jenkins_jobs_home }}/{{ jenkins_job }}.xml
{% endif %}
{% endfor %}

{% for jenkins_job in salt['pillar.get']('jobs_absent') %}
{% if jenkins_job %}
delete_job_{{ jenkins_job }}:
  cmd.run:
    - onlyif: grep -w '{{ jenkins_job }}' /tmp/jenkins_joblist.txt
    - name: {{ jenkins_cli }} delete-job '{{ jenkins_job }}'
    - require:
      - cmd: plugins_jenkins_serving
{% endif %}
{% endfor %}