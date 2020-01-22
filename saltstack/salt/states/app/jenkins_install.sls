java_install:
  pkg.installed:
    - pkgs:
      - openjdk-8-jre-headless

include:
  - jenkins
  - jenkins.cli
  - jenkins.plugins
