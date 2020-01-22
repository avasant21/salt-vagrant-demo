java_{{ salt['pillar.get']('java:config:version') }}:
  pkg.installed:
    - pkgs:
      - openjdk-{{ salt['pillar.get']('java:config:version') }}-jre-headless