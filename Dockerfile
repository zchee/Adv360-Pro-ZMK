# syntax=docker/dockerfile-upstream:1-labs

FROM docker.io/zmkfirmware/zmk-build-arm:stable

WORKDIR /app

COPY --link config/west.yml config/west.yml

# West Init
RUN west init -l config
# West Update
RUN west update
# West Zephyr export
RUN west zephyr-export

COPY --link bin/build.sh ./

CMD ["./build.sh"]
