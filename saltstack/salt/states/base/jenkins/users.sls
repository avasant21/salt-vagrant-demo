{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}


{% for user, args in pillar.get('users', {}).iteritems() %}
{{ user }}:
   cmd.run:
     - unless: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == "{{ user }}"}.getId()' | grep {{ user }}
     - name: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.instance.securityRealm.createAccount("{{ user }}", "{{ args['password'] }}")'
     - require:
       - cmd: plugins_jenkins_serving

{{ user }}_fullname:
   cmd.run:
     - unless: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == "{{ user }}"}' | grep '{{ args['fullname'] }}'
     - name: {{ jenkins_cli }} groovysh 'jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == "{{ user }}"}.setFullName("{{ args['fullname'] }}")'
     - require:
       - cmd: {{ user }}
{% endfor %}