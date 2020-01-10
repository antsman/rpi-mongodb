# rpi-mongodb

![release](https://badgen.net/github/tag/antsman/rpi-mongodb?icon=github&label=latest%20release&color=green)
![pulls](https://badgen.net/docker/pulls/antsman/rpi-mongodb?icon=docker)

- debian based
- latest 32bit mongodb version (3.2.22) from [official repo](https://github.com/mongodb/mongo/releases/tag/r3.2.22)
- adjusted for pi user/group id
- data folder /data/db
- no config file, command line options only
- image about 80MB uncompressed

Build notes from
- https://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/
- https://github.com/mongodb/mongo/wiki/Build-Mongodb-From-Source
- https://github.com/mongodb/mongo/blob/master/docs/building.md
