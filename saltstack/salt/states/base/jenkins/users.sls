{% set jenkins_url = salt['pillar.get']('jenkins:config:master_url') %}
{% set jenkins_cli_path = salt['pillar.get']('jenkins:config:cli_path') %}
{% set jenkins_java_exec = salt['pillar.get']('jenkins:config:java_executable') %}

{% set jenkins_admin_token = "$(cat /var/lib/jenkins/secrets/initialAdminPassword)" %}
{% set jenkins_cli = "{0} -jar {1} -s {2} -http -auth admin:{3}".format(jenkins_java_exec,jenkins_cli_path,jenkins_url,jenkins_admin_token) %}


setup_GlobalMatrixAuthorizationStrategy:
  cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.getAuthorizationStrategy()' | {{ jenkins_cli }} groovysh | grep 'GlobalMatrixAuthorizationStrategy'
    - name: |
        echo -e "import hudson.security.* \n jenkins.model.Jenkins.instance.setSecurityRealm(new HudsonPrivateSecurityRealm(false)) \n jenkins.model.Jenkins.instance.setAuthorizationStrategy(new GlobalMatrixAuthorizationStrategy()) \n jenkins.model.Jenkins.instance.getAuthorizationStrategy().add(jenkins.model.Jenkins.ADMINISTER, 'admin') \n  jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - cmd: plugins_jenkins_serving

{% for user, args in pillar.get('present_users', {}).items() %}
{% if pillar.get('deleted_users') and user not in pillar.get('deleted_users') %}
create_user_{{ user }}:
   cmd.run:
    - unless: echo 'jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == "{{ user }}"}.getId()' | {{ jenkins_cli }} groovysh | grep {{ user }}
    - name: |
         echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("{{ user }}", "{{ args['password'] }}")' | {{ jenkins_cli }} groovysh
         echo 'jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == "{{ user }}"}.setFullName("{{ args['fullname'] }}")' | {{ jenkins_cli }} groovysh
         echo -e "import hudson.model.* \n jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == '{{ user }}'}.addProperty(new hudson.tasks.Mailer.UserProperty('{{ args['email'] }}')) \n jenkins.model.Jenkins.instance.getAuthorizationStrategy().add(jenkins.model.Jenkins.'{{ args['access'] }}', '{{ user }}') \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - cmd: plugins_jenkins_serving
{% endif %}
{% endfor %}

{% for d_user in pillar.get('deleted_users') %}
{% if d_user %}
delete_user_{{ d_user }}:
   cmd.run:
    - onlyif: echo 'jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == "{{ d_user }}"}.getId()' | {{ jenkins_cli }} groovysh | grep {{ d_user }}
    - name: echo -e "import hudson.model.* \n jenkins.model.Jenkins.instance.securityRealm.allUsers.find {it.id == '{{ d_user }}'}.delete() \n jenkins.model.Jenkins.instance.save()" | {{ jenkins_cli }} groovysh
    - require:
      - cmd: plugins_jenkins_serving
{% endif %}
{% endfor %}