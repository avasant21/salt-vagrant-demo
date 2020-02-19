#!jinja|yaml|gpg
os_config:
  lvm:
    disk_name: /dev/sdb
    lv_name: datalv
    lv_size: 45G
    vg_name: datavg
    fs_type: ext4
    fs_name: /home/ftpuser
  
os_users_present:
  ftpuser:
    description: "FTP User for Builds"
    shell: "/bin/false"
    password: |
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
    homedir: /home/ftpuser
  rupam:
    description: "Rupam Khaitan"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/rupam
  ajay:
    description: "Ajay Singh"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/ajay
  anish:
    description: "Anish Bosco M"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/anish
  gmi001:
    description: "Gopal Mishra CNSNG"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/gmi001
  gmi010:
    description: "Gopal Mishra"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/gmi010
  shemna:
    description: "Shemna Beevi K"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/shemna
  sba001:
    description: "Saurabh Baid"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/sba001
  vasanth:
    description: "Vasanth A"
    shell: "/bin/bash"
    password: |
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
    homedir: /home/vasanth

os_users_absent:
  - 