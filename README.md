# docker-generator-m-ionic
Docker for generator-m-ionic


# Build release
1. /build-release.sh /path-to-release-key.keystore key_alias storepass keypass prod appname.v0.0.0.apk


# docker-compose.yml

```yml
appm:
  image: generator-m-ionic
  ports:
    - "3000:3000"
    - "3001:3001"
  volumes:
    - ./appm:/appm
    - /opt/gradle-cache:/home/app/.gradle
    - /dev/bus/usb:/dev/bus/usb

```
