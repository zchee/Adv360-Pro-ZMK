#!/usr/bin/env bash

set -eu

PWD=$(pwd)
TIMESTAMP="${TIMESTAMP:-$(date -u +"%Y%m%d%H%M")}"
COMMIT="${COMMIT:-devel}"

# West Build (left)
west build -s zmk/app -d build/left -b adv360pro_left -- -Wno-dev -DZMK_CONFIG="${PWD}/config"
# Adv360 Left Kconfig file
grep -vE '(^#|^$)' build/left/zephyr/.config
# West Build (right)
west build -s zmk/app -d build/right -b adv360pro_right -- -Wno-dev -DZMK_CONFIG="${PWD}/config"
# Adv360 Right Kconfig file
grep -vE '(^#|^$)' build/right/zephyr/.config
# Rename zmk.uf2
cp build/left/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-left.uf2" && cp build/right/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-right.uf2"
