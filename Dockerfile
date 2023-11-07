# syntax=docker/dockerfile-upstream:master

FROM --platform=$BUILDPLATFORM zmkfirmware/zmk-build-arm:3.2-branch

WORKDIR /app

COPY --link config/west.yml config/west.yml

# West Init
RUN west init -l config
# Set CMake flags
RUN west config build.cmake-args -- "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
# West Update
RUN west update
# West Zephyr export
RUN west zephyr-export

COPY --link bin/build.sh ./

CMD ["./build.sh"]
