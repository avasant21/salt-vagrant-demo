{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

{% for jenkins_jobs in salt['pillar.get']('jobs') %}
copy_xml_{{ jenkins_jobs }}:
  file.managed:
    - unless: {{ jenkins_cli }} get-job {{ jenkins_jobs }}
    - name: /tmp/{{ jenkins_jobs }}.xml
    - source: salt://jenkins/jobs/{{ jenkins_jobs }}.xml
    - require_in:
      - jenkins_job_{{ jenkins_jobs }}
    - require:
      - cmd: plugins_jenkins_serving

jenkins_job_{{ jenkins_jobs }}:
  cmd.run:
    - unless: {{ jenkins_cli }} get-job {{ jenkins_jobs }}
    - name: {{ jenkins_cli }} create-job {{ jenkins_jobs }} < /tmp/{{ jenkins_jobs }}.xml
{% endfor %}
