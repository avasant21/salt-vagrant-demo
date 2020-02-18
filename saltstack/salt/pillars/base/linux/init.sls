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
    shell: ""
    password: "ftpuser@1234"
    homedir: /home/ftpuser
  rupam:
    description: "Rupam Khaitan"
    shell: "/bin/bash"
    password: "rupam@1234"
    homedir: /home/rupam
  ajay:
    description: "Ajay Singh"
    shell: "/bin/bash"
    password: "ajay@1234"
    homedir: /home/ajay
  anish:
    description: "Anish Bosco M"
    shell: "/bin/bash"
    password: "anish@1234"
    homedir: /home/anish
  gmi001:
    description: "Gopal Mishra CNSNG"
    shell: "/bin/bash"
    password: "gmi001@1234"
    homedir: /home/gmi001
  gmi010:
    description: "Gopal Mishra"
    shell: "/bin/bash"
    password: "gmi010@1234"
    homedir: /home/gmi010
  shemna:
    description: "Shemna Beevi K"
    shell: "/bin/bash"
    password: "shemna@1234"
    homedir: /home/shemna
  sba001:
    description: "Saurabh Baid"
    shell: "/bin/bash"
    password: "sba001@1234"
    homedir: /home/sba001
  vasanth:
    description: "Vasanth A"
    shell: "/bin/bash"
    password: "vasanth@1234"
    homedir: /home/vasanth

os_users_absent:
  - 