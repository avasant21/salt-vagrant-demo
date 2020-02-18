{% set ftp_disk_name = salt['pillar.get']('os_config:lvm:disk_name') %}
{% set ftp_lv_name = salt['pillar.get']('os_config:lvm:lv_name') %}
{% set ftp_lv_size = salt['pillar.get']('os_config:lvm:lv_size') %}
{% set ftp_vg_name = salt['pillar.get']('os_config:lvm:vg_name') %}
{% set ftp_fs_name = salt['pillar.get']('os_config:lvm:fs_name') %}
{% set ftp_fs_type = salt['pillar.get']('os_config:lvm:fs_type') %}

{{ ftp_disk_name }}:
  lvm.pv_present

{{ ftp_vg_name }}:
  lvm.vg_present:
    - devices: {{ ftp_disk_name }}
    - require:
      - lvm: {{ ftp_disk_name }}

{{ ftp_lv_name }}:
  lvm.lv_present:
    - vgname: {{ ftp_vg_name }}
    - size: {{ ftp_lv_size }}
    - require:
      - lvm: {{ ftp_vg_name }}

/dev/{{ ftp_vg_name }}/{{ ftp_lv_name }}:
  blockdev.formatted:
    - fs_type: {{ ftp_fs_type }}
    - require:
      - lvm: {{ ftp_lv_name }}

{{ ftp_fs_name }}:
  file.directory:
    - dir_mode: 755

  mount.mounted:
    - device: /dev/{{ ftp_vg_name }}/{{ ftp_lv_name }}
    - fstype: {{ ftp_fs_type }}
    - mkmnt: True
    - persist: True
    - require:
      - blockdev: /dev/{{ ftp_vg_name }}/{{ ftp_lv_name }}

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
      - mount: {{ ftp_fs_name }}
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

