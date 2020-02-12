{% set java_version = salt['pillar.get']('packages:java:version') %}
{% set lvm_version = salt['pillar.get']('packages:lvm:version') %}

openjdk-{{ java_version }}-jre-headless:
  pkg.installed

lvm2:
  pkg.installed:
    - version: {{ lvm_version }}