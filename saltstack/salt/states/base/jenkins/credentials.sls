{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}
{% set jenkins_user = salt['pillar.get']('jenkins:config:user') %}
{% set jenkins_group = salt['pillar.get']('jenkins:config:group') %}
{% set jenkins_cred_home ='/var/log/jenkins/credentials_xml' %}
{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}

{{ jenkins_cred_home }}:
  file.directory:
    - user: {{ jenkins_user }}
    - group: {{ jenkins_group }}
    - mode: 755
    - makedirs: True
    - require:
      - user: jenkins_user
      - group: jenkins_group  

export_credentials_list:
  cmd.run:
    - unless: {{ jenkins_cli }} list-credentials system::system::jenkins > /tmp/jenkins_credentiallist.txt

{% for jenkins_credential in salt['pillar.get']('credentials:create') %}
credentials_xml_{{ jenkins_credential }}:
  file.managed:
    - unless: test -f {{ jenkins_cred_home }}/credential-{{ jenkins_credential }}.xml
    - name: {{ jenkins_cred_home }}/credential-{{ jenkins_credential }}.xml
    - source: salt://jenkins/credentials/credential-{{ jenkins_credential }}.xml
    - require_in:
      - jenkins_credential_{{ jenkins_credential }}
    - require:
      - cmd: plugins_jenkins_serving

jenkins_credential_{{ jenkins_credential }}:
  cmd.run:
    - unless: grep -w 'id-{{ jenkins_credential }}' /tmp/jenkins_credentiallist.txt
    - name: {{ jenkins_cli }} create-credentials-by-xml system::system::jenkins _ < {{ jenkins_cred_home }}/credential-{{ jenkins_credential }}.xml
{% endfor %}
