{% for linux_user, args in salt['pillar.get']('os_users_present', {}).items() %}
{% if pillar.get('os_users_absent') and linux_user not in pillar.get('os_users_absent') %}
adduser_{{ linux_user }}:
  user.present:
    - name: {{ linux_user }}
    - fullname: {{ args['description'] }}
    - shell: {{ args['shell'] }}
    - home: {{ args['homedir'] }}
    - password: {{ args['password'] }}
    - groups:
      - sudo
    {%- if linux_user in 'ftpuser' %}
    - require:
      - mount: {{ salt['pillar.get']('os_config:lvm:fs_name') }}
    {%- endif %}
    
  file.directory:
    - name: {{ args['homedir'] }}
    - user: {{ linux_user }}
    - group: {{ linux_user }}
    - require:
      - user: {{ linux_user }}
{% endif %}
{% endfor %}

{% for linux_user in salt['pillar.get']('os_users_absent') %}
{% if linux_user %}
deleteuser_{{ linux_user }}:
  user.absent:
    - name: {{ linux_user }}
    
  file.absent:
    - name: {{ salt['pillar.get']('os_users_present:%s:homedir' | format(linux_user)) }}
    - require:
      - user: deleteuser_{{ linux_user }}

{% endif %}
{% endfor %}

