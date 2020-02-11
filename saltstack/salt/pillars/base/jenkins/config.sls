configuration:
  parameteried_remote_trigger:
    display_name: cnmaestro-qa-automation
    remote_url: http://10.110.134.132:8080
    username: sanity
    apitoken: 1234567890

  mailer:
    smtp_host: uk01utl04.camnwk.com
    default_suffix: "@cambiumnetworks.com"
    smtp_port: 587

  publish_over_ssh:
    ssh_servers:
      master:
        hostname: in01jenkins01.camnwk.com
        ssh_user: jenkins
        root_dir: /home/ftpuser

    common_config:
      encryptedphrase: ""
      key: ""
      keypath: /var/lib/jenkins/.ssh/id_rsa
  
  publish_over_ftp:
    ftp_servers:
      in01jenkins01:
        hostname: in01jenkins01.camnwk.com
        ftp_user: ftpuser
        ftp_password: ftpuser@1234

  publish_over_cifs:
    cifs_servers:
      cnMaestro_Software_Release:
        hostname: usil01dat02.camnwk.com
        cifs_user: jenkinsbuild
        cifs_password: ftpuser@1234
        remote_dir: common
      cnMaestro_Software_Release_IN01:
        hostname: in01dat01.camnwk.com
        cifs_user: camnwk\\\\\\\\swbuildpublish
        cifs_password: ftpuser@1234
        remote_dir: common
