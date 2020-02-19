#!jinja|yaml|gpg
configuration:
  num_of_executors: 4
  parameteried_remote_trigger:
    display_name: cnmaestro-qa-automation
    remote_url: http://10.110.134.132:8080
    username: sanity
    apitoken: |
        -----BEGIN PGP MESSAGE-----
        Version: GnuPG v1
        
        hQGMA1Fp00HN6XhwAQwAio8AOa+hxtHYB2fL83/B9YfDoiykYW7Bd3gmucXv5HLY
        t0G0cXTgx0O6MLcYRR+LpUbv++2fxQRZxmcpnOPYgU5fv3VKsTiaRTfEJT/Rq7SA
        catHQE8oYOoCk6gyiqkdqtCu1PqVOL5UIFbUxdXGpZLqLE8Jc5Al8hRp7FM2f3Qr
        0nb7yerdKu/C0pWxU3uZU0CdZStGa+gojRi411eKlJXAgwnTE5qGZvtV8dREgNpX
        5iGF57d/fApKijk358lp358mFw0Uve9zNMhaYvu3fRfiUk3Vd0QtsoMRaToPu5pU
        FsfrdA3Y2IQUvKmxqPT004JUHix/iFkbhofmbKMVw9rHUEVmhTwzSn3pJ72WYTFx
        AyYUY7bWHS1a/sgfftACXP6mh0965TogAfJ1qBz8Q5PG/4QIPh6NXIc9ICwqqnwT
        drXnQy2qcSSTtULPrgrha6TQVx9wG4yS883YZ9xnTIcGNvKcm8hjlp3ud9nsrjBT
        1icrM9eJlpGRpN3/SGJc0kYBb+HhK3mU1SrM/lGm/jCGie7lsY/NnD3KEHkGf/GA
        MpyXDnZCLbrGM0fb2LHi11QbH0gGGsTU79jaPLw3TSQnMI2Whdr5
        =9K7I
        -----END PGP MESSAGE-----

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
        ftp_password: |
          -----BEGIN PGP MESSAGE-----
          Version: GnuPG v1
          
          hQGMA1Fp00HN6XhwAQwAio8AOa+hxtHYB2fL83/B9YfDoiykYW7Bd3gmucXv5HLY
          t0G0cXTgx0O6MLcYRR+LpUbv++2fxQRZxmcpnOPYgU5fv3VKsTiaRTfEJT/Rq7SA
          catHQE8oYOoCk6gyiqkdqtCu1PqVOL5UIFbUxdXGpZLqLE8Jc5Al8hRp7FM2f3Qr
          0nb7yerdKu/C0pWxU3uZU0CdZStGa+gojRi411eKlJXAgwnTE5qGZvtV8dREgNpX
          5iGF57d/fApKijk358lp358mFw0Uve9zNMhaYvu3fRfiUk3Vd0QtsoMRaToPu5pU
          FsfrdA3Y2IQUvKmxqPT004JUHix/iFkbhofmbKMVw9rHUEVmhTwzSn3pJ72WYTFx
          AyYUY7bWHS1a/sgfftACXP6mh0965TogAfJ1qBz8Q5PG/4QIPh6NXIc9ICwqqnwT
          drXnQy2qcSSTtULPrgrha6TQVx9wG4yS883YZ9xnTIcGNvKcm8hjlp3ud9nsrjBT
          1icrM9eJlpGRpN3/SGJc0kYBb+HhK3mU1SrM/lGm/jCGie7lsY/NnD3KEHkGf/GA
          MpyXDnZCLbrGM0fb2LHi11QbH0gGGsTU79jaPLw3TSQnMI2Whdr5
          =9K7I
          -----END PGP MESSAGE-----

  publish_over_cifs:
    cifs_servers:
      cnMaestro_Software_Release:
        hostname: usil01dat02.camnwk.com
        cifs_user: jenkinsbuild
        cifs_password: |
          -----BEGIN PGP MESSAGE-----
          Version: GnuPG v1
          
          hQGMA1Fp00HN6XhwAQwAio8AOa+hxtHYB2fL83/B9YfDoiykYW7Bd3gmucXv5HLY
          t0G0cXTgx0O6MLcYRR+LpUbv++2fxQRZxmcpnOPYgU5fv3VKsTiaRTfEJT/Rq7SA
          catHQE8oYOoCk6gyiqkdqtCu1PqVOL5UIFbUxdXGpZLqLE8Jc5Al8hRp7FM2f3Qr
          0nb7yerdKu/C0pWxU3uZU0CdZStGa+gojRi411eKlJXAgwnTE5qGZvtV8dREgNpX
          5iGF57d/fApKijk358lp358mFw0Uve9zNMhaYvu3fRfiUk3Vd0QtsoMRaToPu5pU
          FsfrdA3Y2IQUvKmxqPT004JUHix/iFkbhofmbKMVw9rHUEVmhTwzSn3pJ72WYTFx
          AyYUY7bWHS1a/sgfftACXP6mh0965TogAfJ1qBz8Q5PG/4QIPh6NXIc9ICwqqnwT
          drXnQy2qcSSTtULPrgrha6TQVx9wG4yS883YZ9xnTIcGNvKcm8hjlp3ud9nsrjBT
          1icrM9eJlpGRpN3/SGJc0kYBb+HhK3mU1SrM/lGm/jCGie7lsY/NnD3KEHkGf/GA
          MpyXDnZCLbrGM0fb2LHi11QbH0gGGsTU79jaPLw3TSQnMI2Whdr5
          =9K7I
          -----END PGP MESSAGE-----
        remote_dir: common
      cnMaestro_Software_Release_IN01:
        hostname: in01dat01.camnwk.com
        cifs_user: camnwk\\\\\\\\swbuildpublish
        cifs_password: |
          -----BEGIN PGP MESSAGE-----
          Version: GnuPG v1
          
          hQGMA1Fp00HN6XhwAQwAio8AOa+hxtHYB2fL83/B9YfDoiykYW7Bd3gmucXv5HLY
          t0G0cXTgx0O6MLcYRR+LpUbv++2fxQRZxmcpnOPYgU5fv3VKsTiaRTfEJT/Rq7SA
          catHQE8oYOoCk6gyiqkdqtCu1PqVOL5UIFbUxdXGpZLqLE8Jc5Al8hRp7FM2f3Qr
          0nb7yerdKu/C0pWxU3uZU0CdZStGa+gojRi411eKlJXAgwnTE5qGZvtV8dREgNpX
          5iGF57d/fApKijk358lp358mFw0Uve9zNMhaYvu3fRfiUk3Vd0QtsoMRaToPu5pU
          FsfrdA3Y2IQUvKmxqPT004JUHix/iFkbhofmbKMVw9rHUEVmhTwzSn3pJ72WYTFx
          AyYUY7bWHS1a/sgfftACXP6mh0965TogAfJ1qBz8Q5PG/4QIPh6NXIc9ICwqqnwT
          drXnQy2qcSSTtULPrgrha6TQVx9wG4yS883YZ9xnTIcGNvKcm8hjlp3ud9nsrjBT
          1icrM9eJlpGRpN3/SGJc0kYBb+HhK3mU1SrM/lGm/jCGie7lsY/NnD3KEHkGf/GA
          MpyXDnZCLbrGM0fb2LHi11QbH0gGGsTU79jaPLw3TSQnMI2Whdr5
          =9K7I
          -----END PGP MESSAGE-----
        remote_dir: common
