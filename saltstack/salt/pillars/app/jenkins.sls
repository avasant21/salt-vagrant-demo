jenkins:
  lookup:
    stable: True
    jenkins_port: 8080
    home: /var/jenkins
    user: jenkins
    group: jenkins
    master_url: http://0.0.0.0:8080
    pkgs:
      - jenkins: 2.150.3-1.1
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
        - folders
        - git
        - github
        - github-organization-folder
        - git-parameter
        - gradle
        - jenkins-multijob-plugin
        - junit
        - mailer
        - msbuild
        - nodejs
        - parameterized-trigger
        - pipeline
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
