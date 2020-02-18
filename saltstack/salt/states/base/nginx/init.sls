{% set nginx_version = salt['pillar.get']('packages:nginx:version') %}

nginx_repo:
  pkgrepo.managed:
    - humanname: Nginx Official Repository
    - name: deb http://nginx.org/packages/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} nginx
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/nginx.list
    - key_url: http://nginx.org/keys/nginx_signing.key

install_nginx:
  pkg.installed:
    - name: nginx
    - version: {{ nginx_version }}

jenkins_cert_dir:
  file.directory:
    - name: /etc/nginx/ssl
    - user: root
    - group: root
    - dir_mode: 755
    - require:
      - pkg: nginx
      
jenkins_nginx_conf:
   file.managed:
    - user: root
    - group: root
    - mode: 644
    - names:
      - /etc/nginx/conf.d/jenkins_nginx.conf:
        - source: salt://nginx/files/jenkins_nginx.conf
      - /etc/nginx/ssl/server.crt:
        - source: salt://nginx/files/server.crt
      - /etc/nginx/ssl/server.key:
        - source: salt://nginx/files/server.key
    - require:
      - pkg: nginx
      - file: jenkins_cert_dir

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: nginx
      - file: jenkins_nginx_conf

nginx_reload:
  cmd.run:
    - name: systemctl reload nginx
    - onchanges: 
      - file: jenkins_nginx_conf