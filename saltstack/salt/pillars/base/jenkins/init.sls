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
    master_admin: cnMaestro Jenkins <cnmaestro_jenkins@cambiumnetworks.com>
    pkgs: 
      jenkins:
        version: 2.219
    java_args: -Djava.awt.headless=true
    java_executable: /usr/bin/java
    cli_path: /var/cache/jenkins/jenkins-cli.jar
    cli:
      connection_mode: http
      ssh_user:
      http_auth: admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword)
    plugins:
      updates_source: http://updates.jenkins-ci.org/update-center.json
      timeout: 300
      installed:
        - emailext-template:1.0
        - groovy:2.2
        - publish-over-ssh:1.19
        - ssh-slaves:1.26
        - subversion:2.10.3
        - timestamper:1.10
        - build-timeout:1.19
        - conditional-buildstep:1.3.6
        - ws-cleanup:0.34
        - parameterized-trigger:2.35.2
        - Parameterized-Remote-Trigger:2.2.2
        - configurationslicing:1.47
        - multiple-scms:0.6
        - cvs:2.13
        - build-name-setter:1.6.8
        - rebuild:1.27
        - workflow-cps:2.45
        - random-string-parameter:1.0
        - workflow-support:2.18
        - plot:2.0.3
        - workflow-api:2.26
        - windows-slaves:1.0
        - artifactdeployer:1.2
        - next-build-number:1.5
        - job-restrictions:0.6
        - ui-samples-plugin:2.0
        - bitbucket-build-status-notifier:1.3.3
        - testInProgress:1.4
        - ace-editor:1.1
        - git-changelog:1.57
        - robot:1.6.4
        - htmlpublisher:1.14
        - generic-webhook-trigger:1.28
        - handy-uri-templates-2-api:2.1.6-1.0
        - xvnc:1.23
        - translation:1.16
        - display-url-api:2.2.0
        - jackson2-api:2.8.11.1
        - scm-api:2.2.6
        - branch-api:2.0.18
        - mailcommander:1.0.0
        - cloudbees-folder:6.3
        - cobertura:1.12
        - publish-over-cifs:0.9
        - description-setter:1.10
        - external-monitor-job:1.7
        - durable-task:1.18
        - resource-disposer:0.8
        - antisamy-markup-formatter:1.3
        - flaky-test-handler:1.0.4
        - jquery-detached:1.2.1
        - zentimestamp:4.2
        - workflow-durable-task-step:2.19
        - javadoc:1.4
        - cloudbees-bitbucket-branch-source:2.2.10
        - python:1.3
        - aws-java-sdk:1.11.264
        - copyartifact:1.39
        - s3:0.11.0
        - slack:2.3
        - publish-over-ftp:1.14
        - publish-over:0.21
    jobs:
      installed: {}
      absent: []
