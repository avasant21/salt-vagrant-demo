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
      timeout: 90
      installed:
        - ant
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
        - build-pipeline-plugin
        - build-timeout
        - clearcase
        - conditional-buildstep
        - ws-cleanup
        - bitbucket
        - pipeline-milestone-step
        - pipeline-input-step
        - pipeline-stage-step
        - pipeline-graph-analysis
        - pipeline-rest-api
        - handlebars
        - momentjs
        - pipeline-stage-view
        - pipeline-build-step
        - pipeline-model-api
        - pipeline-model-extensions
        - authentication-tokens
        - docker-commons
        - docker-workflow
        - pipeline-stage-tags-metadata
        - pipeline-model-declarative-agent
        - pipeline-model-definition
        - lockable-resources
        - workflow-aggregator
        - authorize-project
    jobs:
      installed: {}
      absent: []
