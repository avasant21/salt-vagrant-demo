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

/dev/dm-0:
  blockdev.formatted:
    - fs_type: {{ ftp_fs_type }}
    - require:
      - lvm: {{ ftp_lv_name }}

{{ ftp_fs_name }}:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

  mount.mounted:
    - device: /dev/dm-0
    - fstype: {{ ftp_fs_type }}
    - mkmnt: True
    - persist: True
    - require:
      - blockdev: /dev/dm-0
