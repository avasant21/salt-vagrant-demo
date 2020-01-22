jenkins:
  config:
    jenkins_port: 8080
    dir:
      home: /var/lib/jenkins
      log: /var/log/jenkins
      cache: /var/cache/jenkins
    user: jenkins
    group: jenkins
    additional_groups: ["www-data"]
    server_name: localhost
    master_url: http://localhost:8080
    pkgs: ["jenkins"]
    java_args: -Djava.awt.headless=true
    java_executable: /usr/bin/java
    cli_path: /var/cache/jenkins/jenkins-cli.jar
    cli:
      connection_mode: http
      ssh_user:
      http_auth: admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword)
    plugins:
      updates_source: http://updates.jenkins-ci.org/update-center.json
      timeout: 90
      installed:
        - ant
        - bitbucket
        - build-pipeline-plugin
        - build-timeout
        - clearcase
        - conditional-buildstep
        - copyartifact
        - credentials-binding
        - email-ext
        - emailext-template
        - git
        - github
        - github-organization-folder
        - git-parameter
        - gradle
        - groovy
        - jenkins-multijob-plugin
        - junit
        - mailer
        - msbuild
        - nodejs
        - parameterized-trigger
        - publish-over-ssh
        - repo
        - ssh
        - ssh-agent
        - ssh-slaves
        - subversion
        - throttle-concurrents
        - timestamper
        - warnings
        - ws-cleanup
    jobs:
      installed: {}
      absent: []
