packages:
  nginx:
    version: 1.16.1-1~{{ grains['oscodename'] }}
  java:
    version: 8
  lvm:
    version: 2.02.176-4.1{{ grains['osfullname'] | lower() }}3.18.04.2
